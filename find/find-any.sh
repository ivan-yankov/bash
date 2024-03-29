# dsc:Find regular file, directory or symbolic link in the current directory recursively.
# arg:$1 file name or wildcard to search for
function find-any {
  is-defined $1 || return 1
  local what="$1"
  local where="."
  find $where -type f,d,l -name $what 2>/dev/null
}
