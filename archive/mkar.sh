function help-mkar {
  echo "Make archive."
  echo
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
  shift # remove archive name from args, so "$@" is just the files/dirs

  case "$archive" in
    *.tar.gz|*.tgz)
      tar -cvzf "$archive" "$@"
      ;;
    *.tar)
      tar -cvf "$archive" "$@"
      ;;
    *.zip)
      zip -r "$archive" "$@"
      ;;
    *)
      echo "Unsupported archive type: $archive"
      ;;
  esac
}
