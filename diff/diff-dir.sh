function help-diff-dir {
  echo "Compare two directories."
  echo
  echo "Usage: diff-dir dir1 dir2"
}

function diff-dir {
  if [  $# -eq 0  ]; then
    help-diff-dir
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-diff-dir
    return 0
  fi

  diff -qr $1 $2
}
