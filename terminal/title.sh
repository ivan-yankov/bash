# dsc:Set terminal title.
# arg:$1 title fot the current terminal tab
function title {
  is-defined $1 || return 1
  echo -ne "\033]30;$1\007"
}
