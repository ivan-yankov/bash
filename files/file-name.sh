function file-name {
  cmd-dsc "Get the file name without its directory."
  cmd-arg path string "Path to the file"
  cmd-example "file-name /a/b/report.txt"
  cmd-parse "$@" || return $CMD_RC

  basename -- "$ARG_path"
}
