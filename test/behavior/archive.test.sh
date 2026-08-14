# Behaviour of mkar / lsar / exar round trips.

setup() {
  load_commands

  mkdir -p payload/inner
  echo "hello" > payload/greeting.txt
  echo "nested" > payload/inner/deep.txt
}

test_mkar_creates_tar_gz() {
  run mkar out.tar.gz payload
  assert_rc 0 "$rc"
  assert_file out.tar.gz
}

test_mkar_creates_tar() {
  run mkar out.tar payload
  assert_file out.tar
}

test_mkar_creates_zip() {
  run mkar out.zip payload
  assert_file out.zip
}

test_mkar_rejects_unknown_format() {
  run mkar out.rar payload
  assert_contains "$output" "Unsupported archive type"
  [ -f out.rar ] && fail "should not have created out.rar"
  return 0
}

test_mkar_without_arguments_shows_usage() {
  run mkar
  assert_rc_nonzero "$rc"
  assert_contains "$output" "Usage"
}

test_lsar_lists_tar_gz_contents() {
  mkar out.tar.gz payload >/dev/null 2>&1
  run lsar out.tar.gz
  assert_rc 0 "$rc"
  assert_contains "$output" "payload/greeting.txt"
}

test_lsar_lists_zip_contents() {
  mkar out.zip payload >/dev/null 2>&1
  run lsar out.zip
  assert_contains "$output" "payload/greeting.txt"
}

test_lsar_rejects_unknown_format() {
  touch out.rar
  run lsar out.rar
  assert_contains "$output" "Unsupported archive type"
}

test_exar_round_trips_tar_gz() {
  mkar out.tar.gz payload >/dev/null 2>&1
  rm -rf payload
  mkdir restored
  run exar out.tar.gz restored
  assert_rc 0 "$rc"
  assert_file restored/payload/greeting.txt
  assert_eq "hello" "$(cat restored/payload/greeting.txt)"
  assert_file restored/payload/inner/deep.txt
}

test_exar_round_trips_zip() {
  mkar out.zip payload >/dev/null 2>&1
  rm -rf payload
  mkdir restored
  run exar out.zip restored
  assert_file restored/payload/greeting.txt
}

test_exar_defaults_to_current_directory() {
  mkar out.tar.gz payload >/dev/null 2>&1
  rm -rf payload
  run exar out.tar.gz
  assert_file payload/greeting.txt
}

test_exar_rejects_unknown_format() {
  touch out.rar
  run exar out.rar
  assert_rc 2 "$rc"
  assert_contains "$output" "Unsupported archive type"
}
