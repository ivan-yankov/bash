function help-find-any {
  echo "Find regular file, directory or symbolic link in the current directory recursively."
  echo
  echo "Usage: find-any name"
  echo "  name: name or wildcard to search for wraped in double quotes"
}

function find-any {
  if [  $# -eq 0  ]; then
    help-find-any
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-find-any
    return 0
  fi

  local what=$1
  local where="."
  find $where -type f,d,l -name "$what" 2>/dev/null
}
