# dsc:Check flac audio files for curruption.
# arg:$1 directory with flac files
function flac-check {
  is-defined $1 || return 1
  find $1 -type f -iname '*.flac' -print0 | xargs --null flac -wst
}
