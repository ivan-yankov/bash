# dsc:Set read and write access permissions recursively for provided file / directory.
# dsc:Permissions are set for the user, group and others.
# arg:$1 file or directory
function grant-access {
  is-defined $1 || return 1
  sudo chmod -R ugo+rw $1
}
