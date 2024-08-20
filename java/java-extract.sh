function help-java-extract {
  echo "Java extract."
  echo
  echo "Usage: java-extract archive-file-name"
}

function java-extract {
  if [  $# -eq 0  ]; then
    help-java-extract
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-java-extract
    return 0
  fi

  local archive=$1

  exar $archive
  local d=$(arroot $archive)

  mv $d $(dirname $archive)/$(basename $archive .tar.gz)
}
