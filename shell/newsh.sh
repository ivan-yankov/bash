function newsh {
  cmd-dsc "Create a new command from the standard template."
  cmd-dsc "The generated command declares what it takes at the top of its own"
  cmd-dsc "body. Those declarations are the single source of truth for its help"
  cmd-dsc "text, argument parsing and validation."
  cmd-arg name string "Name of the new command, in kebab-case"
  cmd-arg dir dir =. "Directory to create the command in"
  cmd-flag -f --force "Overwrite an existing file"
  cmd-example "newsh convert-audio"
  cmd-example "newsh convert-audio media"
  cmd-parse "$@" || return $CMD_RC

  local cmd=$ARG_name
  local dir=${ARG_dir%/}
  local file="$dir/$cmd.sh"

  if [[ ! $cmd =~ ^[a-z][a-z0-9]*(-[a-z0-9]+)*$ ]]; then
    printf '%snewsh: [%s] is not a valid command name; use lower-case kebab-case%s\n' \
      "$COLOR_RED" "$cmd" "$COLOR_RESET" >&2
    return 1
  fi

  if [ "$ARG_force" != "true" ]; then
    if [ -e "$file" ]; then
      printf '%snewsh: [%s] already exists; pass --force to overwrite%s\n' \
        "$COLOR_RED" "$file" "$COLOR_RESET" >&2
      return 1
    fi
    # A duplicate name would silently shadow the command already loaded.
    if [ -n "${CMD_FILE[$cmd]:-}" ]; then
      printf '%snewsh: command [%s] already exists at [%s]%s\n' \
        "$COLOR_RED" "$cmd" "${CMD_FILE[$cmd]}" "$COLOR_RESET" >&2
      return 1
    fi
  fi

  cat > "$file" <<EOF
function $cmd {
  cmd-dsc "One line describing what the command does."
  cmd-dsc "Add further cmd-dsc lines for detail a reader needs up front."
  cmd-arg source file "Describe this argument"
  cmd-arg target dir =. "Describe this optional argument"
  cmd-flag -v --verbose "Describe this option"
  cmd-example "$cmd input.txt"
  cmd-parse "\$@" || return \$CMD_RC

  # Parsed values arrive as ARG_<name>, already validated.
  echo "source: \$ARG_source"
  echo "target: \$ARG_target"
  echo "verbose: \$ARG_verbose"
}
EOF

  printf '%sCreated %s%s\n' "$COLOR_GREEN" "$file" "$COLOR_RESET"
  printf 'Open a new terminal, or run: source %s\n' "$file"
}
