function help-find-file {
  echo "Find regular file in the current directory recursively."
  echo
  echo "Usage: find-file name"
  echo "  name: file name or wildcard to search for wraped in double quotes"
}

function find-file {
  if [  $# -eq 0  ]; then
    help-find-file
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-find-file
    return 0
  fi

  local what=$1
  local where="."
  find $where -type f -name "$what" 2>/dev/null
}
