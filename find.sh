function find-file {
  is-defined $1 && is-defined $2 || return 1
  local where="$1"
  local what="$2"
  sudo find $where -type f -name $what
}

function find-dir {
  is-defined $1 && is-defined $2 || return 1
  local where="$1"
  local what="$2"
  sudo find $where -type d -name $what
}

function find-link {
  is-defined $1 && is-defined $2 || return 1
  local where="$1"
  local what="$2"
  sudo find $where -type l -name $what
}

function find-any {
  is-defined $1 && is-defined $2 || return 1
  local where="$1"
  local what="$2"
  sudo find $where -type f,d,l -name $what
}
