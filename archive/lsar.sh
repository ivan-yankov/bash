function help-lsar {
  echo "Show archive contents."
  echo
  echo "Usage: lsar archive-file-name"
  echo "Supported formats: zip, tar, tar.gz"
}

function lsar {
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
    unzip -l "$archive"
  elif [[  "$archive" == *.tar  ]]; then
    tar -tf "$archive"
  elif [[  "$archive" == *.tar.gz  ]]; then
    tar -ztf "$archive"
  else
    echo "Unsupported archive type."
  fi
}
