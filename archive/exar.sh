function help-exar {
  echo "Extract archive."
  echo
  echo "Usage: exar archive-file-name"
  echo "Supported formats: zip, tar, tar.gz"
}

function exar {
  if [  $# -eq 0  ]; then
    help-exar
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-exar
    return 0
  fi

  local archive=$1

  if [[  "$archive" == *.zip  ]]; then
    unzip "$@"
  elif [[  "$archive" == *.tar  ]]; then
    tar -xvf "$@"
  elif [[  "$archive" == *.tar.gz  ]]; then
    tar -xvzf "$@"
  else
    echo "Unsupported archive type."
  fi
}
