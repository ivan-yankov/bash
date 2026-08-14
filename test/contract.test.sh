# Contract tests generated from the commands themselves.
#
# Every command that uses cmd-parse gets the same checks for free, so the set
# grows automatically as commands are added.
#
# All three probes are chosen so that cmd-parse rejects the input before the
# command body ever runs. Nothing here executes a real command, which is what
# makes it safe to apply to destructive commands such as docker-clear.

setup() {
  load_commands
}

# Names of commands that call cmd-parse.
migrated_commands() {
  local name file
  for name in "${!CMD_FILE[@]}"; do
    file=${CMD_FILE[$name]}
    declare -F "$name" >/dev/null || continue
    # Match a real call, not the word appearing in a description.
    grep -qE '^[[:space:]]*cmd-parse[[:space:]]' "$file" 2>/dev/null || continue
    printf '%s\n' "$name"
  done | sort
}

# Does the command declare at least one required positional? Read from its own
# help rather than its source, so this tests the public surface.
has_required_argument() {
  local usage
  usage=$("$1" -h 2>/dev/null | grep '^Usage:')
  [[ $usage == *"<"* ]]
}

test_at_least_one_command_is_migrated() {
  local count
  count=$(migrated_commands | wc -l)
  [ "$count" -eq 0 ] && fail "no migrated commands found; this tier covers nothing"
  return 0
}

test_every_command_describes_itself() {
  local name description
  for name in $(migrated_commands); do
    description=$("$name" -h 2>/dev/null | sed -n '2p')
    [ -z "$description" ] && fail "[$name] has no description line"
  done
  return 0
}

test_short_help_flag_exits_zero_and_prints_usage() {
  local name
  for name in $(migrated_commands); do
    run "$name" -h
    [ "$rc" -ne 0 ] && fail "[$name -h] exited $rc, expected 0"
    [[ $output != *"Usage:"* ]] && fail "[$name -h] printed no usage line"
  done
  return 0
}

test_long_help_flag_exits_zero() {
  local name
  for name in $(migrated_commands); do
    run "$name" --help
    [ "$rc" -ne 0 ] && fail "[$name --help] exited $rc, expected 0"
  done
  return 0
}

test_usage_line_is_derived_from_the_declarations() {
  local name
  for name in $(migrated_commands); do
    run "$name" -h
    [[ $output != *"Usage: $name"* ]] && \
      fail "[$name] usage line does not start with the command name"
  done
  return 0
}

test_unknown_option_is_rejected() {
  local name
  for name in $(migrated_commands); do
    run "$name" --zz-definitely-not-an-option
    [ "$rc" -eq 0 ] && fail "[$name] accepted an unknown option instead of failing"
    [[ $output != *"unknown option"* ]] && \
      fail "[$name] rejected an unknown option without saying so"
  done
  return 0
}

test_missing_required_arguments_are_reported() {
  local name
  for name in $(migrated_commands); do
    has_required_argument "$name" || continue
    run "$name"
    [ "$rc" -eq 0 ] && fail "[$name] ran with no arguments despite requiring one"
    [[ $output != *"missing required argument"* ]] && \
      fail "[$name] did not report its missing required argument"
  done
  return 0
}

test_help_is_plain_text_when_not_a_terminal() {
  # cmds -d reads descriptions straight out of this output, so it must not
  # carry escape sequences when captured.
  local name output_text
  for name in $(migrated_commands); do
    output_text=$("$name" -h 2>/dev/null)
    [[ $output_text == *$'\e'* ]] && \
      fail "[$name -h] emitted escape codes into a pipe"
  done
  return 0
}
