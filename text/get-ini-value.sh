# dsc:Get value from .ini file.
# arg:$1 target file
# arg:$2 key to search for
function get-ini-value {
  is-defined $1 && is-defined $2 || return 1
  awk -F "=" '/'$1'/ {print $2}' $2
}
