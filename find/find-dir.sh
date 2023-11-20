# dsc:Find directory.
# arg:$1 file name or wildcard to search for
function find-dir {
  is-defined $1 || return 1
  local what="$1"
  local where="."
  find $where -type d -name $what 2>/dev/null
}
