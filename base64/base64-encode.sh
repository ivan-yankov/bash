# dsc:Encode string to base64.
# arg:$1 string to be encoded
function base64-encode {
  is-defined $1 || return 1
  echo -n $1 | base64
}
