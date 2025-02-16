function help-exar {
  echo "Extract archive."
  echo
  echo "Usage: exar archive-file-name [target-dir]"
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
  shift || true  # now $1 is optional target dir
  local target="${1:-.}"

  case "$archive" in
    *.tar.gz|*.tgz)
      tar -xvzf "$archive" -C "$target"
      ;;
    *.tar)
      tar -xvf "$archive" -C "$target"
      ;;
    *.zip)
      unzip "$archive" -d "$target"
      ;;
    *)
      echo "Unsupported archive type: $archive" >&2
      return 2
      ;;
  esac
}
