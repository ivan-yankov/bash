#!/usr/bin/env python3
"""Lint the command files.

A command is a bash function in a file named after it, which declares what it
takes with cmd-* calls at the top of its own body. This checks that those
declarations are ones cmd-parse can actually use, that every command describes
itself, and that expansions are quoted so values containing spaces survive.

Usage:
    tools/lint-cmds.py                 # lint the repo
    tools/lint-cmds.py path [path...]  # lint specific files or directories
    tools/lint-cmds.py --quiet         # summary only
"""

from __future__ import annotations

import argparse
import re
import shlex
import sys
from dataclasses import dataclass, field
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

# Directories holding library, tooling or test code rather than commands.
SKIP_DIR_MARKER = ".noload"

SIMPLE_TYPES = {"string", "int", "file", "dir", "path", "newpath"}
ENUM_RE = re.compile(r"^enum\([^()|]+(\|[^()|]+)*\)$")
FUNCTION_RE = re.compile(r"^function\s+([A-Za-z0-9_-]+)\s*\{")
NAME_RE = re.compile(r"^[a-z][a-z0-9]*(-[a-z0-9]+)*$")
DECLARATION_RE = re.compile(r"^\s*(cmd-dsc|cmd-arg|cmd-opt|cmd-flag|cmd-env|cmd-example)\b")
PARSE_RE = re.compile(r"^\s*cmd-parse\b")

# Expansions that are never word-split and so are safe bare.
SAFE_EXPANSIONS = {"$#", "$?", "$$", "$!", "$*", "$-", "$_"}

# Contexts where bash does not word-split, so a bare expansion is harmless.
NO_SPLIT_RE = re.compile(r"^\s*(local\s+|declare\s+|export\s+|readonly\s+)?[\w\[\]]+=|"
                         r"\[\[|^\s*\(\(|^\s*case\s|^\s*for\s|^\s*while\s")
NUMERIC_ARG_RE = re.compile(r"^\s*(return|exit|shift)\b")

QUOTED_RE = re.compile(r'"[^"]*"|\'[^\']*\'')
# An expansion whose body already contains a quoted expansion handles its own
# quoting, e.g. ${arr[@]+"${arr[@]}"}.
SELF_QUOTED_RE = re.compile(r'\$\{[^{}]*"[^"]*"[^{}]*\}')
EXPANSION_RE = re.compile(r"\$\{?[A-Za-z_][A-Za-z0-9_]*\}?|\$[0-9]")
HEREDOC_START_RE = re.compile(r"<<-?\s*'?\"?([A-Za-z_][A-Za-z0-9_]*)'?\"?")
CONDITIONAL_RE = re.compile(r"\[\[.*?\]\]")


@dataclass
class Problem:
    path: Path
    line: int
    code: str
    message: str


@dataclass
class Declaration:
    line: int
    kind: str
    tokens: list[str]


@dataclass
class CommandFile:
    path: Path
    name: str
    functions: list[str] = field(default_factory=list)
    declarations: list[Declaration] = field(default_factory=list)
    uses_cmd_parse: bool = False
    declarations_after_parse: list[int] = field(default_factory=list)
    unquoted: list[tuple[int, str]] = field(default_factory=list)


def strip_comment(line: str) -> str:
    """Drop a trailing comment.

    A '#' only starts a comment at the start of a line or after whitespace, so
    this must not cut at the '#' inside an expansion such as ${name# }.
    """
    if line.lstrip().startswith("#"):
        return ""
    for i, ch in enumerate(line):
        if ch == "#" and (i == 0 or line[i - 1].isspace()):
            return line[:i]
    return line


def find_unquoted_expansions(text: str) -> list[tuple[int, str]]:
    """Find expansions used bare where bash would word-split them.

    A heuristic rather than a shell parser, so it errs towards silence.
    """
    found: list[tuple[int, str]] = []
    heredoc_terminator: str | None = None

    for lineno, line in enumerate(text.splitlines(), start=1):
        # Heredoc bodies are literal text, not commands.
        if heredoc_terminator is not None:
            if line.strip() == heredoc_terminator:
                heredoc_terminator = None
            continue

        code = strip_comment(line)

        heredoc = HEREDOC_START_RE.search(code)
        if heredoc:
            heredoc_terminator = heredoc.group(1)
            continue

        if not code.strip():
            continue

        code = SELF_QUOTED_RE.sub(" ", code)

        # Remove quoted spans first; what is left is bare. Doing this before
        # splitting also stops operators inside quotes making bogus segments.
        bare = QUOTED_RE.sub("", code)

        # Nothing inside [[ ]] word-splits.
        bare = CONDITIONAL_RE.sub(" ", bare)
        if "[[" in bare:
            # An unterminated conditional, most likely continued on the next
            # line. Too little context to judge, so say nothing.
            continue

        # One line can hold several commands: `cmd-parse "$@" || return $CMD_RC`
        # is a call followed by a return, and only the call word-splits.
        for segment in re.split(r"\|\||&&|;", bare):
            if not segment.strip():
                continue
            if NO_SPLIT_RE.search(segment) or NUMERIC_ARG_RE.search(segment):
                continue
            for match in EXPANSION_RE.finditer(segment):
                token = match.group(0)
                if token in SAFE_EXPANSIONS:
                    continue
                found.append((lineno, token))
    return found


def iter_command_files(roots: list[Path]):
    for root in roots:
        if not root.is_dir():
            if root.is_file() and root.suffix == ".sh":
                yield root
            continue
        for path in sorted(root.rglob("*.sh")):
            if any((parent / SKIP_DIR_MARKER).exists() for parent in path.parents):
                continue
            yield path


def parse_file(path: Path) -> CommandFile:
    cf = CommandFile(path=path, name=path.stem)
    text = path.read_text(encoding="utf-8", errors="replace")

    seen_parse = False
    heredoc_terminator: str | None = None
    for lineno, line in enumerate(text.splitlines(), start=1):
        # A heredoc body is literal text. The template inside newsh contains
        # cmd-* lines that belong to the generated command, not to newsh.
        if heredoc_terminator is not None:
            if line.strip() == heredoc_terminator:
                heredoc_terminator = None
            continue
        heredoc = HEREDOC_START_RE.search(strip_comment(line))
        if heredoc:
            heredoc_terminator = heredoc.group(1)
            continue

        fn_match = FUNCTION_RE.match(line)
        if fn_match:
            cf.functions.append(fn_match.group(1))
            continue

        if PARSE_RE.match(line):
            cf.uses_cmd_parse = True
            seen_parse = True
            continue

        decl_match = DECLARATION_RE.match(line)
        if decl_match:
            if seen_parse:
                cf.declarations_after_parse.append(lineno)
                continue
            try:
                tokens = shlex.split(strip_comment(line))
            except ValueError:
                # Unbalanced quotes; the syntax check will catch it.
                tokens = []
            if tokens:
                cf.declarations.append(
                    Declaration(line=lineno, kind=tokens[0], tokens=tokens[1:]))

    cf.unquoted = find_unquoted_expansions(text)
    return cf


def check_type(type_token: str) -> bool:
    bare = type_token[:-3] if type_token.endswith("...") else type_token
    return bare in SIMPLE_TYPES or bool(ENUM_RE.match(bare))


def lint_file(cf: CommandFile) -> list[Problem]:
    problems: list[Problem] = []
    rel = cf.path.relative_to(REPO_ROOT) if cf.path.is_relative_to(REPO_ROOT) else cf.path

    def add(line: int, code: str, message: str) -> None:
        problems.append(Problem(rel, line, code, message))

    # A file with no function is a variables or asset file, not a command;
    # colors.sh is the legitimate example.
    if not cf.functions:
        return problems

    if cf.name not in cf.functions:
        add(1, "name-mismatch",
            f"file defines {cf.functions} but no function named '{cf.name}'")

    if not NAME_RE.match(cf.name):
        add(1, "bad-name", f"command name '{cf.name}' is not lower-case kebab-case")

    if not cf.uses_cmd_parse:
        add(1, "no-parse",
            "command never calls cmd-parse, so it has no help and no validation")

    if not any(d.kind == "cmd-dsc" for d in cf.declarations):
        add(1, "no-description", "command has no cmd-dsc line")

    for lineno in cf.declarations_after_parse:
        add(lineno, "late-declaration",
            "declaration comes after cmd-parse, so it is never used")

    seen_names: set[str] = set()
    varargs_at: int | None = None
    optional_seen = False

    for decl in cf.declarations:
        tokens = decl.tokens

        if decl.kind in ("cmd-dsc", "cmd-example"):
            if not tokens:
                add(decl.line, "empty-declaration", f"{decl.kind} has no text")
            continue

        if decl.kind == "cmd-env":
            if len(tokens) < 2 or not tokens[1]:
                add(decl.line, "no-field-description",
                    f"cmd-env '{tokens[0] if tokens else '?'}' has no description")
            continue

        if not tokens:
            add(decl.line, "empty-declaration", f"{decl.kind} has no arguments")
            continue

        if decl.kind == "cmd-flag":
            flags = [t for t in tokens if t.startswith("-")]
            description = tokens[len(flags):]
            if not flags:
                add(decl.line, "bad-option", "cmd-flag declares no -flag")
            for flag in flags:
                if flag in seen_names:
                    add(decl.line, "duplicate", f"option '{flag}' declared twice")
                seen_names.add(flag)
            if not description or not description[0]:
                add(decl.line, "no-field-description",
                    f"cmd-flag '{flags[0] if flags else '?'}' has no description")
            continue

        if decl.kind == "cmd-opt":
            flags = [t for t in tokens if t.startswith("-") and not t.startswith("=")]
            rest = tokens[len(flags):]
            if not flags:
                add(decl.line, "bad-option", "cmd-opt declares no -flag")
            for flag in flags:
                if flag in seen_names:
                    add(decl.line, "duplicate", f"option '{flag}' declared twice")
                seen_names.add(flag)
            type_token = rest[0] if rest else "string"
            if not check_type(type_token):
                add(decl.line, "bad-type",
                    f"option '{flags[0] if flags else '?'}' has unknown type '{type_token}'")
            if type_token.endswith("..."):
                add(decl.line, "opt-varargs", "an option cannot be varargs")
            rest = rest[1:]
            if rest and rest[0].startswith("="):
                rest = rest[1:]
            if not rest or not rest[0]:
                add(decl.line, "no-field-description",
                    f"option '{flags[0] if flags else '?'}' has no description")
            continue

        # cmd-arg
        name = tokens[0]
        type_token = tokens[1] if len(tokens) > 1 else "string"
        has_default = len(tokens) > 2 and tokens[2].startswith("=")
        description = tokens[3:] if has_default else tokens[2:]

        if not check_type(type_token):
            add(decl.line, "bad-type", f"'{name}' has unknown type '{type_token}'")

        if not description or not description[0]:
            add(decl.line, "no-field-description", f"'{name}' has no description")

        if name in seen_names:
            add(decl.line, "duplicate", f"argument '{name}' declared twice")
        seen_names.add(name)

        if varargs_at is not None:
            add(decl.line, "after-varargs",
                f"argument '{name}' comes after the varargs argument, "
                "so it can never be filled")
        if type_token.endswith("..."):
            varargs_at = decl.line
        elif has_default:
            optional_seen = True
        elif optional_seen:
            add(decl.line, "required-after-optional",
                f"required argument '{name}' follows an optional one, "
                "so it can never be filled positionally")

    for lineno, token in cf.unquoted:
        add(lineno, "unquoted",
            f"{token} is unquoted here, so a value with spaces is split")

    return problems


def main() -> int:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("paths", nargs="*", help="files or directories to lint")
    parser.add_argument("--quiet", action="store_true", help="only print the summary")
    args = parser.parse_args()

    roots = [Path(p).resolve() for p in args.paths] if args.paths else [REPO_ROOT]

    files = [parse_file(p) for p in iter_command_files(roots)]
    commands = [cf for cf in files if cf.functions]

    problems: list[Problem] = []
    for cf in files:
        problems.extend(lint_file(cf))

    if problems and not args.quiet:
        for p in sorted(problems, key=lambda x: (str(x.path), x.line)):
            print(f"\033[31m{p.path}:{p.line}\033[0m [{p.code}] {p.message}")
        print()

    problem_color = "\033[31m" if problems else "\033[32m"
    print(f"commands: {len(commands)}   "
          f"problems: {problem_color}{len(problems)}\033[0m")

    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
