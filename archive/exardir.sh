function help-exardir {
  echo "Extract archive to directory."
  echo
  echo "Usage: exardir archive-file-name destination-directory"
  echo "Supported formats: zip, tar, tar.gz"
}

function exardir {
  if [  $# -eq 0  ]; then
    help-exardir
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-exardir
    return 0
  fi

  local f=$1
  local dest=$2

  exar $f
  d=$(arroot $f)
  mv $d $(dirname $f)/$dest
}
