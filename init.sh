function init {
  local root
  root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

  # Honour a pre-set BASH_LOCAL so tests and containers can point the local
  # extension directory somewhere isolated instead of the real ~/.bash.
  export BASH_LOCAL="${BASH_LOCAL:-$HOME/.bash}"

  if [ -z "${BASH_VERSINFO:-}" ] || [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
    echo "This command package requires bash 4 or newer (found ${BASH_VERSION:-unknown})." >&2
    return 1
  fi

  # The library has to exist before anything else, including before this
  # function can describe itself.
  source "$root/shell/colors.sh"
  source "$root/lib/cmd.sh"
  source "$root/shell/load.sh"

  cmd-dsc "Load the command package and the local extension directory."
  cmd-dsc "Call this from .bashrc; it is the entry point of the package."
  cmd-env BASH_LOCAL "Directory holding commands specific to this machine, by default ~/.bash"
  cmd-example "source ~/data/repos/bash/init.sh && init"
  cmd-parse "$@" || return $CMD_RC

  if test -f "$BASH_LOCAL/env.sh"; then
    source "$BASH_LOCAL/env.sh"
  fi

  if test -f "$BASH_LOCAL/alias.sh"; then
    source "$BASH_LOCAL/alias.sh"
  fi

  load "$root"
  # The local extension directory is optional, and load now validates that its
  # argument exists, so check before calling rather than printing an error in
  # every shell that has no ~/.bash.
  [ -d "$BASH_LOCAL" ] && load "$BASH_LOCAL"

  return 0
}
