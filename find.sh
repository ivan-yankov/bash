function find-file {
  is-defined $1 && is-defined $2 || return 1
  local dir="$1"
  local what="$2"
  find $dir -name $what
}

function find-dir {
  is-defined $1 && is-defined $2 || return 1
  local dir="$1"
  local what="$2"
  find $dir -type d -name $what
}
