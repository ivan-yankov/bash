function base64-encode {
  is-defined $1 || return 1
  echo -n $1 | base64
}

function base64-decode {
  is-defined $1 || return 1
  echo $1 | base64 --decode
  echo
}
