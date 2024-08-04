function help-mkar {
  echo "Usage: mkar archive-file-name [file]..."
  echo "Supported formats: zip, tar, tar.gz"
}

function mkar {
  if [  $# -eq 0  ]; then
    help-mkar
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-mkar
    return 0
  fi

  local archive=$1

  if [[  "$archive" == *.zip  ]]; then
    zip -r "$@"
  elif [[  "$archive" == *.tar  ]]; then
    tar -cvf "$@"
  elif [[  "$archive" == *.tar.gz  ]]; then
    tar -cvzf "$@"
  else
    echo "Unsupported archive type."
  fi
}
