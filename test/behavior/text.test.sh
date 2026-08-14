# Behaviour of the text and base64 commands.

setup() {
  load_commands
}

test_base64_encode() {
  run base64-encode "hello"
  assert_rc 0 "$rc"
  assert_eq "aGVsbG8=" "$output"
}

test_base64_decode() {
  run base64-decode "aGVsbG8="
  assert_rc 0 "$rc"
  assert_eq "hello" "$output"
}

test_base64_round_trip() {
  local encoded
  encoded=$(base64-encode "round trip")
  run base64-decode "$encoded"
  assert_eq "round trip" "$output"
}

test_base64_encode_requires_argument() {
  run base64-encode
  assert_rc_nonzero "$rc"
}

test_get_ini_value_reads_key() {
  printf 'ApplicationName=Demo\nVersion=1.2.3\n' > app.ini
  run get-ini-value ApplicationName app.ini
  assert_rc 0 "$rc"
  assert_eq "Demo" "$output"
}

test_get_ini_value_reads_second_key() {
  printf 'ApplicationName=Demo\nVersion=1.2.3\n' > app.ini
  run get-ini-value Version app.ini
  assert_eq "1.2.3" "$output"
}

test_get_ini_value_requires_both_arguments() {
  run get-ini-value ApplicationName
  assert_rc_nonzero "$rc"
}

test_replace_text_substitutes_in_file() {
  echo "the quick brown fox" > sample.txt
  run replace-text "quick" "slow" sample.txt
  assert_rc 0 "$rc"
  assert_eq "the slow brown fox" "$(cat sample.txt)"
}

test_replace_text_is_case_sensitive() {
  echo "Quick quick" > sample.txt
  replace-text "quick" "slow" sample.txt >/dev/null 2>&1
  assert_eq "Quick slow" "$(cat sample.txt)"
}

test_replace_text_without_arguments_shows_usage() {
  run replace-text
  assert_rc_nonzero "$rc"
  assert_contains "$output" "Usage"
}

test_replace_text_help_flag_succeeds() {
  run replace-text -h
  assert_rc 0 "$rc"
  assert_contains "$output" "Usage"
}
