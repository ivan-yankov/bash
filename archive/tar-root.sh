# dsc:Get the name of the tar archive root directory.
# arg:$1 archive file name
function tar-root {
  is-defined $1 || return 1
  lstar "$1" | head -1 | cut -f1 -d "/"
}
