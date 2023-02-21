# dsc:Extract tar archive.
# arg:$1 archive name
function untar {
  tar -xvf "$@"
}
