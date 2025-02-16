function help-replace-all-text {
  echo "Replace text in all files in the current directory."
  echo "Text match is case sensitive."
  echo
  echo "Usage: replace-all-text replace-what replace-width"
}

function replace-all-text {
  if [  $# -eq 0  ]; then
    help-replace-all-text
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-replace-all-text
    return 0
  fi

  grep -rlI "$1" | xargs sed -i "s/$1/$2/g"
}
