# Behaviour of the scaffolder. The generated command has to be immediately
# valid, or the template is teaching the wrong thing.

setup() {
  load_commands
}

test_newsh_creates_the_file() {
  run newsh my-new-command
  assert_rc 0 "$rc"
  assert_file my-new-command.sh
  assert_contains "$output" "Created"
}

test_newsh_creates_in_a_given_directory() {
  mkdir group
  run newsh my-new-command group
  assert_rc 0 "$rc"
  assert_file group/my-new-command.sh
}

test_newsh_rejects_a_non_kebab_case_name() {
  run newsh MyCommand
  assert_rc_nonzero "$rc"
  assert_contains "$output" "kebab-case"
  [ -f MyCommand.sh ] && fail "should not have created the file"
  return 0
}

test_newsh_rejects_a_name_with_spaces() {
  run newsh "two words"
  assert_rc_nonzero "$rc"
  assert_contains "$output" "kebab-case"
}

test_newsh_refuses_to_overwrite_an_existing_file() {
  echo "original" > taken-name.sh
  run newsh taken-name
  assert_rc_nonzero "$rc"
  assert_contains "$output" "already exists"
  assert_eq "original" "$(cat taken-name.sh)"
}

test_newsh_force_overwrites() {
  echo "original" > taken-name.sh
  run newsh taken-name --force
  assert_rc 0 "$rc"
  assert_ne "original" "$(cat taken-name.sh)"
}

test_newsh_refuses_to_shadow_an_existing_command() {
  # mkar is already loaded, so a second one would silently shadow it.
  run newsh mkar
  assert_rc_nonzero "$rc"
  assert_contains "$output" "already exists"
}

test_newsh_rejects_a_missing_target_directory() {
  run newsh my-new-command no-such-dir
  assert_rc_nonzero "$rc"
  assert_contains "$output" "must be an existing directory"
}

test_generated_command_is_valid_bash() {
  newsh my-new-command >/dev/null 2>&1
  run bash -n my-new-command.sh
  assert_rc 0 "$rc" "the generated file is not valid bash"
}

test_generated_command_answers_help() {
  newsh my-new-command >/dev/null 2>&1
  source ./my-new-command.sh

  run my-new-command -h
  assert_rc 0 "$rc"
  assert_contains "$output" "Usage: my-new-command"
  assert_contains "$output" "Arguments:"
  assert_contains "$output" "Options:"
}

test_generated_command_validates_its_arguments() {
  newsh my-new-command >/dev/null 2>&1
  source ./my-new-command.sh

  run my-new-command
  assert_rc 1 "$rc"
  assert_contains "$output" "missing required argument <source>"

  run my-new-command no-such-file.txt
  assert_rc 1 "$rc"
  assert_contains "$output" "must be an existing file"
}

test_generated_command_runs_and_binds_values() {
  newsh my-new-command >/dev/null 2>&1
  source ./my-new-command.sh
  touch input.txt
  mkdir out

  run my-new-command input.txt out --verbose
  assert_rc 0 "$rc"
  assert_contains "$output" "source: input.txt"
  assert_contains "$output" "target: out"
  assert_contains "$output" "verbose: true"
}

test_generated_command_passes_the_linter() {
  newsh my-new-command >/dev/null 2>&1
  run python3 "$REPO_ROOT/tools/lint-cmds.py" my-new-command.sh
  assert_rc 0 "$rc" "the generated command does not pass lint-cmds"
  assert_contains "$output" "problems: "
}
