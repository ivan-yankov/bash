function count {
  cmd-dsc "Show the number of entries in the current directory."
  cmd-example "count"
  cmd-parse "$@" || return $CMD_RC

  ls | wc -l
}
