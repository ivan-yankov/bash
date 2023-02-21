# dsc:List contents of the tar archive.
# arg:$1 archive file name
function lstar {
  tar -tf "$@"
}
