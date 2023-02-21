# dsc:Create tar archive.
# arg:$1 archive file name
# arg:$2... files and directories to be added into the archive
function mktar {
  tar -cvf "$@"
}
