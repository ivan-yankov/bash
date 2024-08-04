function help-newsh {
  echo "Create new shell command."
  echo
  echo "Usage: newsh cmd"
}

function newsh {
  if [  $# -eq 0  ]; then
    help-newsh
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-newsh
    return 0
  fi

  local cmd=$1

  local file=$cmd.sh
  touch $file

  echo "function help-$cmd {" >> $file
  echo '  echo "DESCRIPTION."' >> $file
  echo '  echo' >> $file
  echo "  echo \"Usage: $cmd\"" >> $file
  echo '}' >> $file
  echo >> $file
  echo "function $cmd {" >> $file
  echo '  if [  $# -eq 0  ]; then' >> $file
  echo "    help-$cmd" >> $file
  echo '    return 1' >> $file
  echo '  fi' >> $file
  echo >> $file
  echo '  if [[  $1 == "-h"  ]]; then' >> $file
  echo "    help-$cmd" >> $file
  echo '    return 0' >> $file
  echo '  fi' >> $file
  echo >> $file
  echo '}' >> $file
}
