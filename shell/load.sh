# Recursive worker for load. Kept separate so the declarations and validation
# run once per call rather than once per directory visited.
function __load_dir {
  local dir=$1

  [ -d "$dir" ] || return 0
  [ -f "$dir/.noload" ] && return 0

  local file
  for file in "$dir"/*; do
    if [ -f "$file" ] && [ "${file: -3}" == ".sh" ]; then
      # This file is already sourced by the time it runs, so re-sourcing it
      # would recurse. It still needs registering, or 'load' would be the one
      # command missing from cmds.
      if [ "$file" != "${BASH_SOURCE[0]}" ]; then
        # shellcheck disable=SC1090
        source "$file"
      fi
      # Remember where each command came from, so cmds knows what exists.
      cmd-register-file "$file"
    fi
    if [ -d "$file" ]; then
      __load_dir "$file"
    fi
  done
}

function load {
  cmd-dsc "Load bash sources recursively from a directory."
  cmd-dsc "A directory holding a '.noload' marker is skipped together with"
  cmd-dsc "everything below it, which keeps development-only trees such as the"
  cmd-dsc "tests and tooling out of interactive shells."
  cmd-arg dir dir "Directory to load sources from"
  cmd-example "load ~/.bash"
  cmd-parse "$@" || return $CMD_RC

  __load_dir "$ARG_dir"
}
