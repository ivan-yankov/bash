# dsc:Get available formats for youtube video file.
# env:$PROGRAMS path to the programs directory
function ytd-formats {
  is-defined $PROGRAMS || return 1
  python $(ytd-downloader) -F $1
}
