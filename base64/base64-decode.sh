# dsc:Decode base64 string.
# arg:$1 string to be decoded
function base64-decode {
  is-defined $1 || return 1
  echo $1 | base64 --decode
  echo
}
