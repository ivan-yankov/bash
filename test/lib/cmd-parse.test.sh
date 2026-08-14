# Tests for the declaration API, parser and validators in lib/cmd.sh.

setup() {
  load_commands
}

# Define a throwaway command from its declarations and body.
define_command() {
  local name=$1 declarations=$2 body=${3:-'echo "ran"'}
  eval "function $name {
    $declarations
    cmd-parse \"\$@\" || return \$CMD_RC
    $body
  }"
}

# ------------------------------------------------------------ required args

test_required_positional_is_bound() {
  define_command greet '
    cmd-dsc "Greet someone."
    cmd-arg who string "Who to greet"' \
    'echo "hello $ARG_who"'

  run greet world
  assert_rc 0 "$rc"
  assert_eq "hello world" "$output"
}

test_missing_required_positional_fails() {
  define_command greet '
    cmd-dsc "Greet someone."
    cmd-arg who string "Who to greet"'

  run greet
  assert_rc 1 "$rc"
  assert_contains "$output" "missing required argument <who>"
  assert_contains "$output" "Usage: greet <who>"
}

test_argument_with_spaces_stays_one_argument() {
  define_command greet '
    cmd-dsc "Greet someone."
    cmd-arg who string "Who to greet"' \
    'echo "[$ARG_who]"'

  run greet "two words"
  assert_eq "[two words]" "$output"
}

test_too_many_arguments_fails() {
  define_command greet '
    cmd-dsc "Greet someone."
    cmd-arg who string "Who to greet"'

  run greet a b
  assert_rc 1 "$rc"
  assert_contains "$output" "too many arguments"
}

test_command_with_no_declarations_rejects_arguments() {
  define_command bare '' 'echo "ran"'

  run bare
  assert_rc 0 "$rc"
  assert_eq "ran" "$output"

  run bare unexpected
  assert_rc 1 "$rc"
  assert_contains "$output" "too many arguments"
}

# ------------------------------------------------------------ optional args

test_optional_positional_uses_default() {
  define_command target '
    cmd-dsc "Show target."
    cmd-arg dest string =/tmp "Destination"' \
    'echo "$ARG_dest"'

  run target
  assert_rc 0 "$rc"
  assert_eq "/tmp" "$output"
}

test_optional_positional_can_be_overridden() {
  define_command target '
    cmd-dsc "Show target."
    cmd-arg dest string =/tmp "Destination"' \
    'echo "$ARG_dest"'

  run target /var
  assert_eq "/var" "$output"
}

test_empty_default_makes_a_positional_optional() {
  define_command target '
    cmd-dsc "Show target."
    cmd-arg dest string = "Destination"' \
    'echo "[$ARG_dest]"'

  run target
  assert_rc 0 "$rc"
  assert_eq "[]" "$output"
}

# ------------------------------------------------------------------ options

test_long_option_with_separate_value() {
  define_command conv '
    cmd-dsc "Convert."
    cmd-opt --quality string =medium "Quality"' \
    'echo "$ARG_quality"'

  run conv --quality high
  assert_rc 0 "$rc"
  assert_eq "high" "$output"
}

test_long_option_with_equals_value() {
  define_command conv '
    cmd-dsc "Convert."
    cmd-opt --quality string =medium "Quality"' \
    'echo "$ARG_quality"'

  run conv --quality=high
  assert_eq "high" "$output"
}

test_option_default_applies_when_absent() {
  define_command conv '
    cmd-dsc "Convert."
    cmd-opt --quality string =medium "Quality"' \
    'echo "$ARG_quality"'

  run conv
  assert_eq "medium" "$output"
}

test_short_option_alias_works() {
  define_command conv '
    cmd-dsc "Convert."
    cmd-opt -q --quality string =medium "Quality"' \
    'echo "$ARG_quality"'

  run conv -q low
  assert_eq "low" "$output"
  run conv --quality low
  assert_eq "low" "$output"
}

test_flag_defaults_to_false_and_sets_true() {
  define_command conv '
    cmd-dsc "Convert."
    cmd-flag --replace "Replace original"' \
    'echo "$ARG_replace"'

  run conv
  assert_eq "false" "$output"
  run conv --replace
  assert_eq "true" "$output"
}

test_flag_with_short_alias() {
  define_command conv '
    cmd-dsc "Convert."
    cmd-flag -r --replace "Replace original"' \
    'echo "$ARG_replace"'

  run conv -r
  assert_eq "true" "$output"
}

test_unknown_option_is_rejected() {
  define_command conv '
    cmd-dsc "Convert."
    cmd-opt --quality string =medium "Quality"'

  run conv --nope
  assert_rc 1 "$rc"
  assert_contains "$output" "unknown option [--nope]"
}

test_option_missing_its_value_is_rejected() {
  define_command conv '
    cmd-dsc "Convert."
    cmd-opt --quality string =medium "Quality"'

  run conv --quality
  assert_rc 1 "$rc"
  assert_contains "$output" "requires a value"
}

test_double_dash_forces_positional() {
  define_command greet '
    cmd-dsc "Greet."
    cmd-arg who string "Who to greet"' \
    'echo "[$ARG_who]"'

  run greet -- --looks-like-an-option
  assert_rc 0 "$rc"
  assert_eq "[--looks-like-an-option]" "$output"
}

test_options_may_appear_before_or_after_positionals() {
  define_command conv '
    cmd-dsc "Convert."
    cmd-arg input string "Input"
    cmd-flag --replace "Replace"' \
    'echo "$ARG_input $ARG_replace"'

  run conv --replace file.txt
  assert_eq "file.txt true" "$output"
  run conv file.txt --replace
  assert_eq "file.txt true" "$output"
}

# --------------------------------------------------------------- validators

test_int_type_accepts_integer() {
  define_command retry '
    cmd-dsc "Retry."
    cmd-arg times int "How many times"' \
    'echo "$ARG_times"'

  run retry 5
  assert_rc 0 "$rc"
  assert_eq "5" "$output"
}

test_int_type_rejects_non_integer() {
  define_command retry '
    cmd-dsc "Retry."
    cmd-arg times int "How many times"'

  run retry abc
  assert_rc 1 "$rc"
  assert_contains "$output" "must be an integer"
}

test_file_type_accepts_existing_file() {
  touch real.txt
  define_command show '
    cmd-dsc "Show."
    cmd-arg target file "A file"' \
    'echo "$ARG_target"'

  run show real.txt
  assert_rc 0 "$rc"
  assert_eq "real.txt" "$output"
}

test_file_type_rejects_missing_file() {
  define_command show '
    cmd-dsc "Show."
    cmd-arg target file "A file"'

  run show absent.txt
  assert_rc 1 "$rc"
  assert_contains "$output" "must be an existing file"
}

test_file_type_rejects_a_directory() {
  mkdir adir
  define_command show '
    cmd-dsc "Show."
    cmd-arg target file "A file"'

  run show adir
  assert_rc 1 "$rc"
  assert_contains "$output" "must be an existing file"
}

test_dir_type_accepts_existing_directory() {
  mkdir adir
  define_command show '
    cmd-dsc "Show."
    cmd-arg target dir "A directory"' \
    'echo "$ARG_target"'

  run show adir
  assert_rc 0 "$rc"
  assert_eq "adir" "$output"
}

test_dir_type_rejects_a_file() {
  touch afile
  define_command show '
    cmd-dsc "Show."
    cmd-arg target dir "A directory"'

  run show afile
  assert_rc 1 "$rc"
  assert_contains "$output" "must be an existing directory"
}

test_path_type_accepts_file_or_directory() {
  touch afile
  mkdir adir
  define_command show '
    cmd-dsc "Show."
    cmd-arg target path "Anything existing"' \
    'echo "$ARG_target"'

  run show afile
  assert_eq "afile" "$output"
  run show adir
  assert_eq "adir" "$output"
}

test_enum_accepts_declared_choice() {
  define_command conv '
    cmd-dsc "Convert."
    cmd-arg quality "enum(low|high)" "Quality"' \
    'echo "$ARG_quality"'

  run conv high
  assert_rc 0 "$rc"
  assert_eq "high" "$output"
}

test_enum_rejects_other_values() {
  define_command conv '
    cmd-dsc "Convert."
    cmd-arg quality "enum(low|high)" "Quality"'

  run conv medium
  assert_rc 1 "$rc"
  assert_contains "$output" "must be one of: low, high"
}

test_enum_option_with_default() {
  define_command conv '
    cmd-dsc "Convert."
    cmd-opt --vq "enum(low|high)" =high "Quality"' \
    'echo "$ARG_vq"'

  run conv
  assert_eq "high" "$output"
  run conv --vq low
  assert_eq "low" "$output"
  run conv --vq nope
  assert_rc 1 "$rc"
  assert_contains "$output" "must be one of: low, high"
}

test_newpath_accepts_missing_file_in_existing_dir() {
  define_command out '
    cmd-dsc "Write."
    cmd-arg dest newpath "Where to write"' \
    'echo "$ARG_dest"'

  run out ./new-file.txt
  assert_rc 0 "$rc"
  assert_eq "./new-file.txt" "$output"
}

test_newpath_rejects_missing_parent() {
  define_command out '
    cmd-dsc "Write."
    cmd-arg dest newpath "Where to write"'

  run out ./no-such-dir/new-file.txt
  assert_rc 1 "$rc"
  assert_contains "$output" "must be inside an existing directory"
}

# ------------------------------------------------------------------ varargs

test_varargs_collects_remaining_arguments() {
  define_command bundle '
    cmd-dsc "Bundle."
    cmd-arg archive string "Archive name"
    cmd-arg sources string... "Files to include"' \
    'echo "$ARG_archive : ${ARG_sources[*]} (${#ARG_sources[@]})"'

  run bundle out.zip a b c
  assert_rc 0 "$rc"
  assert_eq "out.zip : a b c (3)" "$output"
}

test_varargs_may_be_empty() {
  define_command bundle '
    cmd-dsc "Bundle."
    cmd-arg archive string "Archive name"
    cmd-arg sources string... "Files to include"' \
    'echo "count=${#ARG_sources[@]}"'

  run bundle out.zip
  assert_rc 0 "$rc"
  assert_eq "count=0" "$output"
}

test_varargs_preserve_spaces_in_elements() {
  define_command bundle '
    cmd-dsc "Bundle."
    cmd-arg sources string... "Files"' \
    'printf "[%s]" "${ARG_sources[@]}"; echo'

  run bundle "one two" "three"
  assert_eq "[one two][three]" "$output"
}

test_varargs_validate_each_element() {
  touch good.txt
  define_command bundle '
    cmd-dsc "Bundle."
    cmd-arg archive string "Archive name"
    cmd-arg sources file... "Files to include"'

  run bundle out.zip good.txt missing.txt
  assert_rc 1 "$rc"
  assert_contains "$output" "must be an existing file"
}

# -------------------------------------------------------------- state reset

test_flag_does_not_leak_between_invocations() {
  define_command conv '
    cmd-dsc "Convert."
    cmd-flag --replace "Replace original"' \
    'echo "$ARG_replace"'

  run conv --replace
  assert_eq "true" "$output"
  run conv
  assert_eq "false" "$output" "flag leaked from the previous invocation"
}

test_positional_does_not_leak_between_invocations() {
  define_command target '
    cmd-dsc "Show target."
    cmd-arg dest string =/tmp "Destination"' \
    'echo "$ARG_dest"'

  run target /var
  assert_eq "/var" "$output"
  run target
  assert_eq "/tmp" "$output" "positional leaked from the previous invocation"
}

test_varargs_does_not_leak_between_invocations() {
  define_command bundle '
    cmd-dsc "Bundle."
    cmd-arg sources string... "Files"' \
    'echo "count=${#ARG_sources[@]}"'

  run bundle a b c
  assert_eq "count=3" "$output"
  run bundle
  assert_eq "count=0" "$output" "varargs leaked from the previous invocation"
}

test_declarations_do_not_accumulate_across_calls() {
  # Calling twice must not register the same parameters again, which would
  # make the second call believe it has two positionals.
  define_command greet '
    cmd-dsc "Greet."
    cmd-arg who string "Who to greet"' \
    'echo "$ARG_who"'

  run greet world
  assert_eq "world" "$output"
  run greet world
  assert_eq "world" "$output" "declarations accumulated between calls"
  run greet -h
  local occurrences
  occurrences=$(grep -c 'Who to greet' <<<"$output")
  assert_eq "1" "$occurrences" "parameter listed more than once in help"
}

test_declarations_from_an_abandoned_command_are_not_reused() {
  # A command that declares parameters and then returns before parsing must
  # not leave them behind for whatever runs next.
  eval 'function abandons {
    cmd-dsc "Abandons."
    cmd-arg ghost string "Should not appear elsewhere"
    return 0
  }'
  define_command victim '
    cmd-dsc "Victim."' \
    'echo "ran"'

  abandons
  run victim
  assert_rc 0 "$rc"
  assert_eq "ran" "$output"

  run victim -h
  assert_not_contains "$output" "ghost"
  assert_not_contains "$output" "Abandons."
}

test_a_command_calling_another_command_keeps_its_own_values() {
  define_command inner '
    cmd-dsc "Inner."
    cmd-arg value string "Inner value"' \
    'echo "inner=$ARG_value"'

  eval 'function outer {
    cmd-dsc "Outer."
    cmd-arg value string "Outer value"
    cmd-parse "$@" || return $CMD_RC
    local mine=$ARG_value
    inner nested
    echo "outer=$mine"
  }'

  run outer top
  assert_rc 0 "$rc"
  assert_contains "$output" "inner=nested"
  assert_contains "$output" "outer=top"
}

# --------------------------------------------------------------------- help

test_help_flag_exits_zero_without_running_body() {
  define_command greet '
    cmd-dsc "Greet someone."
    cmd-arg who string "Who to greet"' \
    'echo "BODY RAN"'

  run greet -h
  assert_rc 0 "$rc"
  assert_not_contains "$output" "BODY RAN"
  assert_contains "$output" "Greet someone."
}

test_long_help_flag_also_works() {
  define_command greet '
    cmd-dsc "Greet someone."
    cmd-arg who string "Who to greet"' \
    'echo "BODY RAN"'

  run greet --help
  assert_rc 0 "$rc"
  assert_not_contains "$output" "BODY RAN"
}

test_help_renders_every_section() {
  define_command conv '
    cmd-dsc "Convert a video."
    cmd-arg input string "Input file"
    cmd-arg dest string =. "Destination"
    cmd-opt -q --quality "enum(low|high)" =high "Quality"
    cmd-flag --replace "Replace original"
    cmd-env FFMPEG_BIN "ffmpeg binary"
    cmd-example "conv a.mkv --quality low"'

  run conv -h
  assert_contains "$output" "Convert a video."
  assert_contains "$output" "Usage: conv"
  assert_contains "$output" "<input>"
  assert_contains "$output" "[dest]"
  assert_contains "$output" "Arguments:"
  assert_contains "$output" "Options:"
  assert_contains "$output" "-q, --quality"
  assert_contains "$output" "default: high"
  assert_contains "$output" "Environment:"
  assert_contains "$output" "FFMPEG_BIN"
  assert_contains "$output" "Examples:"
  assert_contains "$output" "conv a.mkv --quality low"
}

test_help_second_line_is_the_first_description() {
  # cmds -d reads exactly this line, so its position is part of the contract.
  define_command greet '
    cmd-dsc "Greet someone politely."
    cmd-dsc "More detail here."'

  run greet -h
  assert_eq "Greet someone politely." "$(sed -n '2p' <<<"$output")"
}

test_validation_failure_prints_usage() {
  define_command greet '
    cmd-dsc "Greet."
    cmd-arg who string "Who to greet"'

  run greet
  assert_contains "$output" "Usage: greet <who>"
}

test_all_validation_errors_are_reported_together() {
  define_command pair '
    cmd-dsc "Pair."
    cmd-arg count int "A number"
    cmd-opt --quality "enum(low|high)" =low "Quality"'

  run pair notanumber --quality nope
  assert_rc 1 "$rc"
  assert_contains "$output" "must be an integer"
  assert_contains "$output" "must be one of: low, high"
}
