# dsc:Load bash sources from the current directory and ~/.bash directory recursively.
# dsc:This function should be defined as entry point in .bashrc.
function init {
  local root=$(dirname $BASH_SOURCE)
  source $root/shell/is-defined.sh
  source $root/shell/load.sh

  load $root

  export BASH_LOCAL=~/.bash
  load $BASH_LOCAL
}
