function help-init {
  echo "Load bash sources from the bash project directory and ~/.bash directory recursively."
  echo "This function should be defined as entry point in .bashrc."
}

function init {
  if [[  $1 == "-h"  ]]; then
    help-init
    return 0
  fi

  local root=$(dirname $BASH_SOURCE)
  export BASH_LOCAL=~/.bash

  source $root/shell/is-defined.sh
  source $root/shell/load.sh

  if test -f $BASH_LOCAL/env.sh; then
    source $BASH_LOCAL/env.sh
  fi

  if test -f $BASH_LOCAL/alias.sh; then
    source $BASH_LOCAL/alias.sh
  fi

  load $root
  load $BASH_LOCAL
}
