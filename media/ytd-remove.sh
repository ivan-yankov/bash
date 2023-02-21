# dsc:Remove youtube downloader tool.
# env:$PROGRAMS path to the programs directory
function ytd-remove {
  is-defined $PROGRAMS || return 1
  sudo rm -rf $(dirname $(ytd-downloader))
}
