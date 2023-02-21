# dsc:Calculate size of the file / directory.
# arg:$1 file or directory
function size {
  is-defined $1 || return 1
  sudo du -sh $1
}
