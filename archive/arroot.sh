function help-arroot {
  echo "Get the name of the tar archive root directory."
  echo
  echo "Usage: arroot archive-file-name"
  echo "Supported formats: zip, tar, tar.gz"
}

function arroot {
  if [  $# -eq 0  ]; then
    help-arroot
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-arroot
    return 0
  fi

  lsar "$1" | head -1 | cut -f1 -d "/"
}
