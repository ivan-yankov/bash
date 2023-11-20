# dsc:Find symbolic link.
# arg:$1 file name or wildcard to search for
function find-link {
  is-defined $1 || return 1
  local what="$1"
  local where="."
  find $where -type l -name $what 2>/dev/null
}
