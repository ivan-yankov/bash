# dsc:Create zip archive.
# arg:$1 archive file name
# arg:$2... files and directories to be added into the archive
function mkzip {
  zip -r "$@"
}
