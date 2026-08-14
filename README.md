# bash command package

A personal collection of shell commands, loaded into every interactive shell.

Commands are grouped into directories for readability only. Grouping has no
effect on execution: everything is loaded recursively and every command is
available by name in the terminal.

## Install

Add one line to `~/.bashrc`:

```bash
source ~/data/repos/bash/init.sh && init
```

Machine-specific commands go in `~/.bash/`, which is loaded recursively the
same way. `~/.bash/env.sh` and `~/.bash/alias.sh` are sourced first if present.
Set `BASH_LOCAL` before `init` to point that directory somewhere else.

Requires bash 4 or newer.

## Using commands

```bash
cmds              # list every command
cmds git          # list commands whose name contains "git"
cmds -d docker    # list them with descriptions
mkar -h           # full help for one command
```

Every command answers `-h` and `--help` itself. There is no separate `help`
command, because a command's help is generated from the same declarations that
parse its arguments.

## Writing a command

```bash
newsh convert-audio media    # create media/convert-audio.sh from the template
```

A command is a bash function in a file named after it. It declares what it
takes with a few calls at the top of its own body, and `cmd-parse` turns those
declarations into help text, parsing and validation. Nothing ever reads the
source file to find out what a command does.

```bash
function convert-video {
  cmd-dsc  "Convert video to mp4 format for archiving."
  cmd-dsc  "Add further cmd-dsc lines for detail a reader needs up front."
  cmd-arg  input file                                     "Video file to convert"
  cmd-arg  target dir =.                                  "Directory to write into"
  cmd-opt  --vq "enum(lossless|high|medium|low)" =medium   "Video quality"
  cmd-flag -r --replace                                   "Replace the original file"
  cmd-env  FFMPEG_BIN                                     "ffmpeg binary to use"
  cmd-example "convert-video a.mkv --vq high --replace"
  cmd-parse "$@" || return $CMD_RC

  ffmpeg -i "$ARG_input" ...
}
```

Parsed values arrive as `ARG_<name>`, with `-` replaced by `_`, already
validated. The single line `cmd-parse "$@" || return $CMD_RC` is the whole
contract: it returns non-zero whenever the body should not run, and puts the
command's intended exit code in `CMD_RC`.

### Declarations

| Call | Meaning |
| --- | --- |
| `cmd-dsc <text>` | Description line. Repeatable. |
| `cmd-arg <name> <type> [=default] <text>` | Positional parameter. |
| `cmd-opt <flag>... <type> [=default] <text>` | Option taking a value. |
| `cmd-flag <flag>... <text>` | Option taking no value. |
| `cmd-env <NAME> <text>` | Environment variable the command reads. |
| `cmd-example <text>` | Example invocation. Repeatable. |

A positional with a default is optional; one without is required, and required
positionals must come before optional ones. A type ending in `...` collects the
remaining arguments into an array and must be declared last.

Options may be given several spellings: `cmd-flag -r --replace "..."` accepts
both, and binds to the long one, here `ARG_replace`. Flags default to `false`
and become `true` when passed.

All declarations must appear **before** `cmd-parse`; anything after it is never
seen. `--` ends option parsing, so a value that starts with `-` can still be
passed as a positional.

### Types

| Type | Accepts |
| --- | --- |
| `string` | anything |
| `int` | an integer |
| `file` | an existing regular file |
| `dir` | an existing directory |
| `path` | any existing path |
| `newpath` | a path whose parent directory exists |
| `enum(a\|b\|c)` | one of the listed values |

A type containing `(` or `\|` **must be quoted**, because bash would otherwise
read it as syntax:

```bash
cmd-opt --vq "enum(lossless|high|medium|low)" =medium "Video quality"
```

## Development

```bash
make test          # run the suite in a container
make test-local    # run it directly on this machine
make test-matrix   # run it on every supported distribution
make lint          # check the command declarations
make check         # lint + containerised tests
make test F=archive   # only tests matching "archive"
```

The container run is the one that counts: it has none of your `~/.bash`, mounts
the repo read-only, and gives the test user passwordless sudo so commands that
use `sudo` run unattended.

`lint-cmds` is also a command in its own right. It reports commands whose file
name and function name disagree, commands with no description, declarations
`cmd-parse` could not use, declarations placed after `cmd-parse`, and unquoted
expansions that would split a value containing spaces.

### Tests

Test files are `test/**/*.test.sh`. Every `test_*` function runs in its own
subshell in a fresh temporary directory.

```bash
setup() { load_commands; }

test_file_ext_returns_extension() {
  run file-ext /a/b/report.txt
  assert_rc 0 "$rc"
  assert_eq "txt" "$output"
}
```

`run` captures stdout and stderr into `$output` and the exit code into `$rc`
without aborting the test. Assertions available: `assert_eq`, `assert_ne`,
`assert_contains`, `assert_not_contains`, `assert_matches`, `assert_rc`,
`assert_rc_nonzero`, `assert_file`, `assert_dir`, plus `fail` and `skip`. A
test can record several failures before finishing, and a test whose subshell
dies before completing is reported as a failure rather than a pass.

There are three tiers:

- **Contract tests** (`test/contract.test.sh`) apply to every command
  automatically: it describes itself, `-h` works and prints usage, unknown
  options are rejected, missing required arguments are reported, and help is
  plain text when piped. All probes are rejected by `cmd-parse` before the
  command body runs, which is what makes them safe for destructive commands
  such as `docker-clear`.
- **Library tests** (`test/lib/`) cover the declaration API, parser and
  validators.
- **Behaviour tests** (`test/behavior/`) cover commands with real output and no
  user interaction.

### Layout

Directories carrying a `.noload` marker are skipped by the loader, so they
never enter an interactive shell.

| Path | Contents |
| --- | --- |
| `init.sh` | entry point for `.bashrc` |
| `lib/cmd.sh` | declaration API, parser, validators, help rendering |
| `shell/` | loader and shell helpers |
| `test/` | test runner and suites |
| `tools/` | declaration linter |
| `ci/` | test container and its runner |
| everything else | command groups |
