function flac-test {
  dir=$1
  find $dir -type f -iname '*.flac' -print0 | xargs --null flac -wst
}
