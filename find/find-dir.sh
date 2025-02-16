function help-find-dir {
  echo "Find directory in the current directory recursively."
  echo
  echo "Usage: find-dir name"
  echo "  name: directory name or wildcard to search for wraped in double quotes"
}

function find-dir {
  if [  $# -eq 0  ]; then
    help-find-dir
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-find-dir
    return 0
  fi

  local what=$1
  local where="."
  find $where -type d -name "$what" 2>/dev/null
}
