function help-find-link {
  echo "Find symbolic link in the current directory recursively."
  echo
  echo "Usage: find-link name"
  echo "  name: link name or wildcard to search for wraped in double quotes"
}

function find-link {
  if [  $# -eq 0  ]; then
    help-find-link
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-find-link
    return 0
  fi

  local what=$1
  local where="."
  find $where -type l -name "$what" 2>/dev/null
}
