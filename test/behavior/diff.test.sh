# Behaviour of diff-dir.

setup() {
  load_commands

  mkdir -p left/sub right/sub
  echo "same" > left/same.txt
  echo "same" > right/same.txt
  echo "one" > left/differs.txt
  echo "two" > right/differs.txt
  echo "only here" > left/only-left.txt
}

test_diff_dir_reports_differing_file() {
  run diff-dir left right
  assert_rc_nonzero "$rc"
  assert_contains "$output" "differs.txt"
}

test_diff_dir_reports_missing_file() {
  run diff-dir left right
  assert_contains "$output" "only-left.txt"
}

test_diff_dir_does_not_report_identical_file() {
  run diff-dir left right
  assert_not_contains "$output" "same.txt"
}

test_diff_dir_on_identical_trees_is_silent() {
  rm left/only-left.txt right/differs.txt left/differs.txt
  run diff-dir left right
  assert_rc 0 "$rc"
  assert_eq "" "$output"
}

test_diff_dir_without_arguments_shows_usage() {
  run diff-dir
  assert_rc_nonzero "$rc"
  assert_contains "$output" "Usage"
}
