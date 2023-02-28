# dsc:Find regular file, directory or symbolic link.
# arg:$1 directory to search in
# arg:$2 file name or wildcard to search for
function find-any {
  is-defined $1 && is-defined $2 || return 1
  local where="$1"
  local what="$2"
  sudo find $where -type f,d,l -name $what
}
