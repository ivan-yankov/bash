function size {
  cmd-dsc "Show the size of a file or directory."
  cmd-arg target path "File or directory to measure"
  cmd-example "size ~/data"
  cmd-parse "$@" || return $CMD_RC

  sudo du -sh "$ARG_target"
}
