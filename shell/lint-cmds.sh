function lint-cmds {
  cmd-dsc "Check the command files for declaration problems."
  cmd-dsc "Reports commands whose file name and function name disagree,"
  cmd-dsc "commands with no description, and declarations cmd-parse could not"
  cmd-dsc "use. Also reports unquoted expansions, which split on whitespace."
  cmd-arg target dir = "Directory to lint, defaults to the whole package"
  cmd-flag -q --quiet "Print only the summary"
  cmd-example "lint-cmds"
  cmd-example "lint-cmds media"
  cmd-parse "$@" || return $CMD_RC

  local linter="${CMD_FILE[lint-cmds]%/shell/lint-cmds.sh}/tools/lint-cmds.py"
  if [ ! -f "$linter" ]; then
    printf 'lint-cmds: linter not found at [%s]\n' "$linter" >&2
    return 1
  fi

  local args=()
  [ -n "$ARG_target" ] && args+=("$ARG_target")
  [ "$ARG_quiet" == "true" ] && args+=(--quiet)

  python3 "$linter" ${args[@]+"${args[@]}"}
}
