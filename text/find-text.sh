# dsc:Find text in the current directory recursively.
# arg:$1 text to search for
function find-text {
  is-defined $1 || return 1
  grep -rlI "$1"
}
