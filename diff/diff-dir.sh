# dsc:Compare two directories.
# arg:$1 first directory
# arg:$2 second directory
function diff-dir {
  is-defined $1 && is-defined $2 || return 1
  diff -qr $1 $2
}
