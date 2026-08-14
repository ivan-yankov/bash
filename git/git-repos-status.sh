function git-repos-status {
  cmd-dsc "Show the status of every git repository in the current directory."
  cmd-dsc "Run this in the directory that holds the repositories."
  cmd-example "git-repos-status"
  cmd-parse "$@" || return $CMD_RC

  local d
  for d in */; do
    [ -d "$d/.git" ] || continue
    printf '%s%s%s\n' "$COLOR_GREEN" "$d" "$COLOR_RESET"
    # A subshell keeps the caller's working directory intact even when the
    # repository command fails.
    ( cd "$d" && git status )
    echo
  done
}
