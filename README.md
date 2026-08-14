# bash command package

A personal collection of shell commands, loaded into every interactive shell.

## Overview

Commands are bash functions, each in a file named after it. They are grouped
into directories for readability only — grouping does not affect execution, and
every command is available by name in the terminal.

A command declares what it takes with a few calls at the top of its own body.
Those declarations produce its help text, argument parsing and validation, so
each command is described exactly once and nothing has to read the source file
to find out what it does. There is therefore no separate `help` command: every
command answers `-h` itself.

| Path | Contents |
| --- | --- |
| `init.sh` | entry point for `.bashrc` |
| `lib/cmd.sh` | declaration API, parser, validators, help |
| `shell/` | loader and shell helpers |
| `test/` | test runner and suites |
| `tools/` | declaration linter |
| `ci/` | test container and its runner |
| `Makefile` | test and lint targets |
| everything else | command groups |

Directories carrying a `.noload` marker are skipped by the loader, so the
development trees never enter an interactive shell.

## Installation

Add one line to `~/.bashrc` or `~/.bash_profile` depends what you youse and the OS:

```bash
source ~/data/repos/bash/init.sh && init
```

Requires bash 4 or newer.

Machine-specific commands go in `~/.bash/`, loaded recursively the same way.
`~/.bash/env.sh` and `~/.bash/alias.sh` are sourced first if present. Set
`BASH_LOCAL` before `init` to use a different directory.

## Usage

```bash
cmds              # list every command
cmds git          # list commands whose name contains "git"
cmds -d docker    # list them with descriptions
mkar -h           # full help for one command
```

## Creating a command

```bash
newsh convert-audio media    # create media/convert-audio.sh from the template
```

The template is a working command; edit its declarations and body:

```bash
function convert-video {
  cmd-dsc  "Convert video to mp4 format for archiving."
  cmd-arg  input file                                    "Video file to convert"
  cmd-arg  target dir =.                                 "Directory to write into"
  cmd-opt  --vq "enum(lossless|high|medium|low)" =medium  "Video quality"
  cmd-flag -r --replace                                  "Replace the original file"
  cmd-env  FFMPEG_BIN                                    "ffmpeg binary to use"
  cmd-example "convert-video a.mkv --vq high --replace"
  cmd-parse "$@" || return $CMD_RC

  ffmpeg -i "$ARG_input" ...
}
```

| Declaration | Meaning |
| --- | --- |
| `cmd-dsc <text>` | Description line. Repeatable. |
| `cmd-arg <name> <type> [=default] <text>` | Positional parameter. |
| `cmd-opt <flag>... <type> [=default] <text>` | Option taking a value. |
| `cmd-flag <flag>... <text>` | Option taking no value. |
| `cmd-env <NAME> <text>` | Environment variable the command reads. |
| `cmd-example <text>` | Example invocation. Repeatable. |

| Type | Accepts |
| --- | --- |
| `string` | anything |
| `int` | an integer |
| `file` | an existing regular file |
| `dir` | an existing directory |
| `path` | any existing path |
| `newpath` | a path whose parent directory exists |
| `enum(a\|b\|c)` | one of the listed values |

Rules worth knowing:

- `cmd-parse "$@" || return $CMD_RC` is the whole contract. It returns non-zero
  whenever the body should not run, and puts the intended exit code in `CMD_RC`.
- Values arrive as `ARG_<name>`, with `-` replaced by `_`, already validated.
- **Quote any type containing `(` or `|`** — bash reads `enum(a|b)` bare as a
  syntax error.
- A positional with a default is optional and must come after the required
  ones. A type ending in `...` collects the rest into an array and comes last.
- Options accept several spellings and bind to the long one: `-r --replace`
  sets `ARG_replace`. Flags are `false` unless passed.
- All declarations must precede `cmd-parse`; anything after it is ignored.

Check your work with `lint-cmds`, which reports file and function names that
disagree, missing descriptions, declarations `cmd-parse` cannot use or that sit
after it, and unquoted expansions that would split a value containing spaces.

## Testing

```bash
make test          # run the suite in a container
make lint          # check the command declarations
make check         # both
make test-local    # run the suite on this machine
make test-matrix   # run it on every supported distribution
make test F=archive   # only tests matching "archive"
```

The container run is the one that counts: it has none of your `~/.bash`, mounts
the repo read-only, and gives the test user passwordless sudo so commands using
`sudo` run unattended.

Test files are `test/**/*.test.sh`. Each `test_*` function runs in its own
subshell in a fresh temporary directory:

```bash
setup() { load_commands; }

test_file_ext_returns_extension() {
  run file-ext /a/b/report.txt
  assert_rc 0 "$rc"
  assert_eq "txt" "$output"
}
```

`run` captures stdout and stderr into `$output` and the exit code into `$rc`
without aborting the test. Assertions: `assert_eq`, `assert_ne`,
`assert_contains`, `assert_not_contains`, `assert_matches`, `assert_rc`,
`assert_rc_nonzero`, `assert_file`, `assert_dir`, plus `fail` and `skip`. A test
can record several failures, and one whose subshell dies is reported as a
failure rather than a pass.

Three tiers:

- **`test/contract.test.sh`** — applies to every command automatically: it
  describes itself, `-h` prints usage, unknown options are rejected, missing
  required arguments are reported, help is plain text when piped. Every probe is
  rejected by `cmd-parse` before the body runs, which makes this safe even for
  destructive commands such as `docker-clear`.
- **`test/lib/`** — the declaration API, parser and validators.
- **`test/behavior/`** — commands with real output and no user interaction.

### Testing a new command

A new command joins the contract tier the moment it exists — nothing to wire up.
That already covers its help, its rejection of unknown options and its required
arguments. What it does not cover is what the command actually *does*, which is
what a behaviour test is for.

Say you have just written `text/line-count.sh`:

```bash
function line-count {
  cmd-dsc "Count the lines in a file."
  cmd-arg file file "File to count"
  cmd-flag -q --quiet "Print only the number"
  cmd-parse "$@" || return $CMD_RC

  local n
  n=$(wc -l < "$ARG_file")
  if [ "$ARG_quiet" == "true" ]; then echo "$n"; else echo "$ARG_file: $n"; fi
}
```

Create `test/behavior/line-count.test.sh` next to the other behaviour suites.
Name it after the command, or after the group when several related commands are
tested together, as `archive.test.sh` does for `mkar`/`exar`/`lsar`.

```bash
setup() {
  load_commands
  printf 'one\ntwo\nthree\n' > notes.txt
}

test_line_count_reports_the_file_and_count() {
  run line-count notes.txt
  assert_rc 0 "$rc"
  assert_eq "notes.txt: 3" "$output"
}

test_line_count_quiet_prints_only_the_number() {
  run line-count notes.txt --quiet
  assert_eq "3" "$output"
}

test_line_count_rejects_a_missing_file() {
  run line-count absent.txt
  assert_rc 1 "$rc"
  assert_contains "$output" "must be an existing file"
}
```

Then run just your suite:

```bash
make test-local F=line-count   # fast, on this machine
make test F=line-count         # in the container
```

Notes:

- `setup` must call `load_commands`, which loads the package the way an
  interactive shell does. It runs before each test.
- Every test starts in its own empty temporary directory, so build fixtures with
  plain `printf`, `touch` and `mkdir` in `setup` or in the test itself. Nothing
  needs cleaning up, and the repo is mounted read-only in the container to catch
  a command that writes into the source tree.
- Assert on behaviour you have decided, not on incidental formatting. Prefer
  `assert_contains` over `assert_eq` for messages that may be reworded.
- The filter matches a file name or a test function name, so `F=line-count` and
  `F=quiet` both work.

For a command that cannot run unattended — hardware, installers, GUI, network
login — write no behaviour test. The contract tier still covers its interface,
and that is the honest amount of coverage.
