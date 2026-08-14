function find-link {
  cmd-dsc "Find a symbolic link in the current directory recursively."
  cmd-arg pattern string "Name or wildcard to search for; quote wildcards"
  cmd-example 'find-link "*.txt"'
  cmd-parse "$@" || return $CMD_RC

  find . -type l -name "$ARG_pattern" 2>/dev/null
}
