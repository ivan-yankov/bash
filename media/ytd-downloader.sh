# dsc:Get path to the youtube downloader tool.
# env:$PROGRAMS path to the programs directory
function ytd-downloader {
  is-defined $PROGRAMS || return 1
  echo $PROGRAMS/youtube/youtube-dl
}
