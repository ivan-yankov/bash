function find-dir {
  cmd-dsc "Find a directory in the current directory recursively."
  cmd-arg pattern string "Name or wildcard to search for; quote wildcards"
  cmd-example 'find-dir "*.txt"'
  cmd-parse "$@" || return $CMD_RC

  find . -type d -name "$ARG_pattern" 2>/dev/null
}
