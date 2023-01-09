function text-find {
  is-defined $1 || return 1
  grep -rlI $1
}

function text-find-verbose {
  is-defined $1 || return 1
  grep -rInH $1
}

function text-find-ignore-case {
  is-defined $1 || return 1
  grep -rIinH $1
}

function text-replace {
  is-defined $1 && is-defined $2 && is-defined $3 || return 1
  local what=$1
  local with=$2
  local file=$3
  sed -i "s/$what/$with/" $file
}

function text-replace-all {
  is-defined $1 && is-defined $2 || return 1
  grep -rlI "$1" | xargs sed -i "s/$1/$2/g"
}

function text-get-ini-value {
  is-defined $1 && is-defined $2 || return 1
  awk -F "=" '/'$1'/ {print $2}' $2
}
