# dsc:Download youtube video to the current directory in the best format available.
# env:$PROGRAMS path to the programs directory
# arg:$1 link to the youtube video
function ytd-download {
  is-defined $PROGRAMS &&  is-defined $1 || return 1
  local fmt=$(ytd-formats $1 | grep best | cut -d ' ' -f1)
  python $(ytd-downloader) -f $fmt $1
}
