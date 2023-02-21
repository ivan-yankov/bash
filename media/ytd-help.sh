# dsc:Show help for youtube downloader tool.
# env:$PROGRAMS path to the programs directory
function ytd-help {
  is-defined $PROGRAMS || return 1
  python $(ytd-downloader) --help
}
