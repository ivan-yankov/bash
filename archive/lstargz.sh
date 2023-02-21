# dsc:List contents of the tar gun zip archive file.
# arg:$1 archive file name
function lstargz {
  tar -ztf "$@"
}
