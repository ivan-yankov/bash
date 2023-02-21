# dsc:Load bash sources from the repository and ~/.bash directory recursively.
# dsc:This function should be defined as entry point in .bashrc.
function init {
  local root=$(dirname $BASH_SOURCE)
  source $root/shell/is-defined.sh
  source $root/shell/load.sh

  export BASH_LOCAL=~/.bash
  export CMDS=()

  load $BASH_LOCAL
  load $(dirname $BASH_SOURCE)
}
