function help-cmds {
  echo "Show list of custom functions."
  echo "Expects BASH_LOCAL environment variable."
  echo "  BASH_LOCAL: directory which contains bash files specific to the local machine."
}

function cmds {
  if [[  $1 == "-h"  ]]; then
    help-cmds
    return 0
  fi

  collect-cmds $(dirname $BASH_SOURCE)
  collect-cmds $BASH_LOCAL
}
