# dsc:Set current user ownership recursively for the file / directory.
# arg:$1 file or directory
function own {
  is-defined $1 || return 1
  sudo chown --recursive $USER $1
}
