function help-replace-text {
  echo "Replace text in the specified file."
  echo "Text match is case sensitive."
  echo "Requires python."
  echo
  echo "Usage: replace-text what with file"
  echo "  what: text to search for"
  echo "  with: text to replace with"
  echo "  file: file to search in"
}

function replace-text {
  if [  $# -eq 0  ]; then
    help-replace-text
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-replace-text
    return 0
  fi

  local what=$1
  local with=$2
  local file_name=$3

  python -c "import sys
with open(\"$file_name\", 'r') as file:
  data = file.read()
  data = data.replace(\"$what\", \"$with\")

with open(\"$file_name\", 'w') as file:
  file.write(data)"
}
