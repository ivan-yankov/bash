# dsc:Get file name without path.
# arg:$1 path to the file
function file-name {
  is-defined $1 || return 1
  basename -- "$1"
}
