function find-file {
  cmd-dsc "Find a regular file in the current directory recursively."
  cmd-arg pattern string "Name or wildcard to search for; quote wildcards"
  cmd-example 'find-file "*.txt"'
  cmd-parse "$@" || return $CMD_RC

  find . -type f -name "$ARG_pattern" 2>/dev/null
}
