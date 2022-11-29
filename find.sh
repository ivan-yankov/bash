function find-file {
  find . -name "$@"
}

function find-dir {
  find . -type d -name "$@"
}

function find-text {
  grep -rl "$@"
}

function find-text-verbose {
  grep -rIinH "$@"
}

function find-text-cs {
  grep -rInH "$@"
}

function replace-text {
  grep -rl "$1" | xargs sed -i "s/$1/$2/g"
}
