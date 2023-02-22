# dsc:Find directory.
# dsc:Follow symbolic links on search.
# arg:$1 directory to search in
# arg:$2 file name or wildcard to search for
function find-dir {
  is-defined $1 && is-defined $2 || return 1
  local where="$1"
  local what="$2"
  sudo find -L $where -type d -name $what
}
