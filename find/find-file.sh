# dsc:Find regular file.
# arg:$1 file name or wildcard to search for
function find-file {
  is-defined $1 || return 1
  local what="$1"
  local where="."
  find $where -type f -name $what 2>/dev/null
}
