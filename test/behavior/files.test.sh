# Behaviour of the file-name / path helper commands.

setup() {
  load_commands
}

test_file_name_strips_directory() {
  run file-name /a/b/c/report.txt
  assert_rc 0 "$rc"
  assert_eq "report.txt" "$output"
}

test_file_name_handles_spaces() {
  run file-name "/a/b/my report.txt"
  assert_eq "my report.txt" "$output"
}

test_file_name_of_bare_name() {
  run file-name report.txt
  assert_eq "report.txt" "$output"
}

test_file_ext_returns_extension() {
  run file-ext /a/b/report.txt
  assert_rc 0 "$rc"
  assert_eq "txt" "$output"
}

test_file_ext_takes_last_extension() {
  run file-ext /a/b/archive.tar.gz
  assert_eq "gz" "$output"
}

test_file_name_without_ext() {
  run file-name-without-ext /a/b/report.txt
  assert_rc 0 "$rc"
  assert_eq "report" "$output"
}

test_file_name_without_ext_strips_only_last() {
  run file-name-without-ext /a/b/archive.tar.gz
  assert_eq "archive.tar" "$output"
}

test_file_name_without_ext_handles_spaces() {
  run file-name-without-ext "/a/b/my report.txt"
  assert_eq "my report" "$output"
}

# A leading dash makes the parser see an option, so such a path is passed
# after '--'. The command must then hand it on the same way internally.
test_file_name_accepts_a_leading_dash_path_after_separator() {
  run file-name -- "-report.txt"
  assert_rc 0 "$rc"
  assert_eq "-report.txt" "$output"
}

test_file_ext_accepts_a_leading_dash_path_after_separator() {
  run file-ext -- "-report.txt"
  assert_rc 0 "$rc"
  assert_eq "txt" "$output"
}

test_file_name_without_ext_accepts_a_leading_dash_path_after_separator() {
  run file-name-without-ext -- "-report.txt"
  assert_rc 0 "$rc"
  assert_eq "-report" "$output"
}

test_file_name_requires_argument() {
  run file-name
  assert_rc_nonzero "$rc"
}

test_file_ext_requires_argument() {
  run file-ext
  assert_rc_nonzero "$rc"
}

test_count_counts_entries_in_current_directory() {
  touch one two three
  mkdir subdir
  run count
  assert_rc 0 "$rc"
  assert_eq "4" "${output// /}"
}

test_count_on_empty_directory() {
  run count
  assert_eq "0" "${output// /}"
}
