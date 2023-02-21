# dsc:Get file name without path and extension.
# arg:$1 path to the file
function file-name-without-ext {
  is-defined $1 || return 1
  local fn=$(file-name "$1")
  echo "${fn%.*}"
}
