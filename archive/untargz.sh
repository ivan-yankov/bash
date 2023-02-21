# dsc:Extract tar gun zip archive.
# arg:$1 archive file name
function untargz {
  tar -xvzf "$@"
}
