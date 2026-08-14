function file-ext {
  cmd-dsc "Get the extension of a file path."
  cmd-arg path string "Path to the file"
  cmd-example "file-ext /a/b/report.txt"
  cmd-parse "$@" || return $CMD_RC

  local name
  name=$(file-name "$ARG_path")
  echo "${name##*.}"
}
