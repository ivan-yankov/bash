function cmds {
  cmd-dsc "Show the list of available commands."
  cmd-dsc "Covers both the command package and the local extension directory."
  cmd-arg filter string = "Only show commands whose name contains this text"
  cmd-flag -d --describe "Show each command's first description line"
  cmd-env BASH_LOCAL "Directory holding commands specific to this machine"
  cmd-example "cmds"
  cmd-example "cmds docker"
  cmd-example "cmds -d git"
  cmd-parse "$@" || return $CMD_RC

  local name
  local names=()
  for name in "${!CMD_FILE[@]}"; do
    # A file may hold variables or helpers rather than a command.
    declare -F "$name" >/dev/null || continue
    if [ -n "$ARG_filter" ] && [[ $name != *"$ARG_filter"* ]]; then
      continue
    fi
    names+=("$name")
  done

  [ ${#names[@]} -eq 0 ] && return 0

  local sorted
  mapfile -t sorted < <(printf '%s\n' "${names[@]}" | sort)

  if [ "$ARG_describe" != "true" ]; then
    printf '%s\n' "${sorted[@]}"
    return 0
  fi

  # Descriptions come from each command's own help. Asking a command for help
  # never runs its body, so this is safe even for destructive commands.
  local description
  for name in "${sorted[@]}"; do
    description=$("$name" -h 2>/dev/null | sed -n '2p')
    printf '%s%-32s%s %s\n' \
      "$COLOR_MAGENTA" "$name" "$COLOR_RESET" "$description"
  done
}
