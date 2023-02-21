# dsc:Find text in the current directory recursively.
# dsc:Text match is case insensitive.
# arg:$1 text to search for
function find-text-ignore-case {
  is-defined $1 || return 1
  grep -rIinH $1
}
