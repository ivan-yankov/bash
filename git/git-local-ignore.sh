function git-local-ignore {
  cmd-dsc "Ignore files locally, without changing .gitignore."
  cmd-dsc "The files to ignore are listed one per line in a .git-local-ignore"
  cmd-dsc "file in the repository root. Run this from inside the repository."
  cmd-arg state "enum(on|off)" "Whether to start or stop ignoring the files"
  cmd-example "git-local-ignore on"
  cmd-example "git-local-ignore off"
  cmd-parse "$@" || return $CMD_RC

  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "git-local-ignore: not inside a git repository" >&2
    return 1
  }

  local list="$root/.git-local-ignore"
  if [ ! -f "$list" ]; then
    echo "git-local-ignore: no [$list] file" >&2
    return 1
  fi

  local files=()
  mapfile -t files < <(grep -v '^[[:space:]]*$' "$list")

  local exclude_file="$root/.git/info/exclude"
  local file

  case "$ARG_state" in
    on)
      : > "$exclude_file"
      for file in "${files[@]}"; do
        printf '%s\n' "$file" >> "$exclude_file"
      done
      for file in "${files[@]}"; do
        printf 'Ignoring file %s\n' "$file"
        git update-index --skip-worktree "$file"
      done
      ;;
    off)
      : > "$exclude_file"
      for file in "${files[@]}"; do
        printf 'Stop ignoring file %s\n' "$file"
        git update-index --no-skip-worktree "$file"
      done
      ;;
  esac
}
