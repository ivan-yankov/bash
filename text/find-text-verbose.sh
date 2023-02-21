# dsc:Find text in the current directory recursively.
# dsc:Show the files and the line numbers of the text matches.
# arg:$1 text to search for
function find-text-verbose {
  is-defined $1 || return 1
  grep -rInH $1
}
