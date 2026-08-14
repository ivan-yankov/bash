function file-name-without-ext {
  cmd-dsc "Get the file name without its directory and extension."
  cmd-arg path string "Path to the file"
  cmd-example "file-name-without-ext /a/b/report.txt"
  cmd-parse "$@" || return $CMD_RC

  local name
  name=$(file-name -- "$ARG_path")
  echo "${name%.*}"
}
