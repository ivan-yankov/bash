# dsc:Get file extension from file path.
# arg:$1 path to the file
function file-ext {
  is-defined $1 || return 1
  local fn=$(file-name "$1")
  echo "${fn##*.}"
}
