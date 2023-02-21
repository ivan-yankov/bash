# dsc:Get the name of the tar gun zip archive root directory.
# arg: archive file name
function targz-root {
  is-defined $1 || return 1
  lstargz "$1" | head -1 | cut -f1 -d "/"
}
