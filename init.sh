# dsc:Load bash sources from the repository and ~/.bash directory recursively.
# dsc:This function should be defined as entry point in .bashrc.
function init {
  export BASH_LOCAL=~/.bash

  source $BASH_LOCAL/bash/shell/is-defined.sh
  source $BASH_LOCAL/bash/shell/load.sh

  load $BASH_LOCAL
}
