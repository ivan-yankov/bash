function find-any {
  cmd-dsc "Find a regular file, directory or symbolic link in the current"
  cmd-dsc "directory recursively."
  cmd-arg pattern string "Name or wildcard to search for; quote wildcards"
  cmd-example 'find-any "alpha*"'
  cmd-parse "$@" || return $CMD_RC

  find . -type f,d,l -name "$ARG_pattern" 2>/dev/null
}
