function diff-dir {
  cmd-dsc "Compare two directories recursively, reporting which files differ."
  cmd-arg left dir "First directory"
  cmd-arg right dir "Second directory"
  cmd-example "diff-dir ./a ./b"
  cmd-parse "$@" || return $CMD_RC

  diff -qr "$ARG_left" "$ARG_right"
}
