# Behaviour of the find-* family.

setup() {
  load_commands

  mkdir -p top/nested
  touch top/alpha.txt
  touch top/nested/beta.txt
  touch top/nested/alpha.log
  mkdir -p top/alpha.d
  ln -s top/alpha.txt alpha.link
}

test_find_file_matches_by_name() {
  run find-file "alpha.txt"
  assert_rc 0 "$rc"
  assert_contains "$output" "top/alpha.txt"
}

test_find_file_matches_wildcard() {
  run find-file "*.txt"
  assert_contains "$output" "top/alpha.txt"
  assert_contains "$output" "top/nested/beta.txt"
  assert_not_contains "$output" "alpha.log"
}

test_find_file_excludes_directories() {
  run find-file "alpha.d"
  assert_eq "" "$output"
}

test_find_dir_matches_directories_only() {
  run find-dir "alpha.d"
  assert_contains "$output" "top/alpha.d"
}

test_find_dir_excludes_regular_files() {
  run find-dir "alpha.txt"
  assert_eq "" "$output"
}

test_find_link_matches_symlinks() {
  run find-link "alpha.link"
  assert_contains "$output" "alpha.link"
}

test_find_any_matches_files_and_dirs() {
  run find-any "alpha*"
  assert_contains "$output" "top/alpha.txt"
  assert_contains "$output" "top/alpha.d"
  assert_contains "$output" "alpha.link"
}

test_find_file_without_argument_shows_usage() {
  run find-file
  assert_rc_nonzero "$rc"
  assert_contains "$output" "Usage"
}

test_find_file_help_flag_succeeds() {
  run find-file -h
  assert_rc 0 "$rc"
  assert_contains "$output" "Usage"
}
