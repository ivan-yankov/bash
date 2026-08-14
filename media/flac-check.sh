function flac-check {
  cmd-dsc "Check flac files in a directory for corruption, recursively."
  cmd-arg target dir "Directory holding the flac files"
  cmd-example "flac-check ~/music"
  cmd-parse "$@" || return $CMD_RC

  find "$ARG_target" -type f -iname '*.flac' -print0 | xargs --null flac -wst
}
