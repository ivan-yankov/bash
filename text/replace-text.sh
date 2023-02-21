# dsc:Replace text in the specified file.
# dsc:Text match is case sensitive.
# arg:$1 text to search for
# arg:$2 text to replace with
# arg:$3 file to search in
function replace-text {
  is-defined $1 && is-defined $2 && is-defined $3 || return 1
  local what=$1
  local with=$2
  local file=$3
  sed -i "s/$what/$with/" $file
}
