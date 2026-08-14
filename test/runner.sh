#!/usr/bin/env bash
# Minimal test runner for the bash command library.
#
# A test file is any *.test.sh under test/. It is sourced by this runner, and
# every function named test_* in it is executed in its own subshell, inside a
# fresh temporary directory.
#
# Usage: test/runner.sh [name-filter]

set -u

TEST_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(dirname "$TEST_ROOT")
export TEST_ROOT REPO_ROOT

_c_red=$'\e[31m'
_c_green=$'\e[32m'
_c_yellow=$'\e[33m'
_c_cyan=$'\e[36m'
_c_dim=$'\e[2m'
_c_reset=$'\e[0m'
if [ ! -t 1 ]; then
  _c_red=""; _c_green=""; _c_yellow=""; _c_cyan=""; _c_dim=""; _c_reset=""
fi

# State shared with the per-test subshells lives in files, because a subshell
# cannot write back into its parent's variables.
STATE_DIR=$(mktemp -d "${TMPDIR:-/tmp}/bashtest-state.XXXXXX")
trap 'rm -rf "$STATE_DIR"' EXIT
export STATE_DIR

FAILURE_FILE="$STATE_DIR/failures"
SKIP_FILE="$STATE_DIR/skip"
export FAILURE_FILE SKIP_FILE

# ---------------------------------------------------------------- assertions

# Record a failure for the current test. Does not abort the test, so one test
# can report several problems in a single run.
fail() {
  printf '%s\n\x1e' "$1" >>"$FAILURE_FILE"
}

assert_eq() {
  local expected=$1 actual=$2 msg=${3:-"values differ"}
  if [ "$expected" != "$actual" ]; then
    fail "$msg
  expected: [$expected]
  actual:   [$actual]"
  fi
}

assert_ne() {
  local unexpected=$1 actual=$2 msg=${3:-"values should differ"}
  if [ "$unexpected" = "$actual" ]; then
    fail "$msg
  both were: [$actual]"
  fi
}

assert_contains() {
  local haystack=$1 needle=$2 msg=${3:-"expected substring not found"}
  if [[ $haystack != *"$needle"* ]]; then
    fail "$msg
  looking for: [$needle]
  in:          [$haystack]"
  fi
}

assert_not_contains() {
  local haystack=$1 needle=$2 msg=${3:-"unexpected substring found"}
  if [[ $haystack == *"$needle"* ]]; then
    fail "$msg
  should not contain: [$needle]
  in:                 [$haystack]"
  fi
}

assert_matches() {
  local haystack=$1 regex=$2 msg=${3:-"expected pattern not matched"}
  if [[ ! $haystack =~ $regex ]]; then
    fail "$msg
  pattern: [$regex]
  in:      [$haystack]"
  fi
}

assert_rc() {
  local expected=$1 actual=$2 msg=${3:-"unexpected exit code"}
  if [ "$expected" != "$actual" ]; then
    fail "$msg
  expected rc: $expected
  actual rc:   $actual"
  fi
}

assert_rc_nonzero() {
  local actual=$1 msg=${2:-"expected a non-zero exit code"}
  if [ "$actual" -eq 0 ]; then
    fail "$msg (got 0)"
  fi
}

assert_file() {
  [ -f "$1" ] || fail "${2:-expected file to exist}: [$1]"
}

assert_dir() {
  [ -d "$1" ] || fail "${2:-expected directory to exist}: [$1]"
}

# Mark the current test as skipped. Everything after this still runs, so call
# it and return.
skip() {
  printf '%s' "${1:-skipped}" >"$SKIP_FILE"
}

# Run a command, capturing stdout+stderr into $output and the code into $rc.
# Never aborts the test run when the command fails.
run() {
  output=$( "$@" 2>&1 )
  rc=$?
  return 0
}

# Same, but evaluates a string, for pipelines and shell syntax.
run_eval() {
  output=$( eval "$1" 2>&1 )
  rc=$?
  return 0
}

# ------------------------------------------------------------------ fixtures

# Overridable per test file.
setup() { :; }
teardown() { :; }

# Load the command library the way a real interactive shell would.
load_commands() {
  export BASH_LOCAL="${BASH_LOCAL:-$STATE_DIR/bash-local}"
  mkdir -p "$BASH_LOCAL"
  # shellcheck disable=SC1091
  source "$REPO_ROOT/init.sh"
  init
}

# ------------------------------------------------------------------- running

run_test_function() {
  local fn=$1

  : >"$FAILURE_FILE"
  : >"$SKIP_FILE"

  local sandbox
  sandbox=$(mktemp -d "${TMPDIR:-/tmp}/bashtest.XXXXXX")

  local stderr_file="$STATE_DIR/stderr"
  # Commands run without `set -u` because an interactive shell does not have
  # it, and several commands legitimately probe unset positionals such as $5.
  # Running them stricter than production would test a different program.
  (
    set +u
    cd "$sandbox" || exit 1
    setup
    "$fn"
    teardown
  ) >/dev/null 2>"$stderr_file"
  local subshell_rc=$?

  rm -rf "$sandbox"

  # A test whose subshell died before reaching teardown recorded no failures,
  # which must never be mistaken for success.
  if [ "$subshell_rc" -ne 0 ]; then
    fail "test aborted before completing (exit $subshell_rc)"
  fi

  local skip_reason
  skip_reason=$(cat "$SKIP_FILE" 2>/dev/null)
  if [ -n "$skip_reason" ]; then
    printf "  %s-%s %s %s(%s)%s\n" \
      "$_c_yellow" "$_c_reset" "$fn" "$_c_dim" "$skip_reason" "$_c_reset"
    echo skip >>"$STATE_DIR/results"
    return 0
  fi

  if [ ! -s "$FAILURE_FILE" ]; then
    printf "  %s✓%s %s\n" "$_c_green" "$_c_reset" "$fn"
    echo pass >>"$STATE_DIR/results"
    return 0
  fi

  printf "  %s✗ %s%s\n" "$_c_red" "$fn" "$_c_reset"
  while IFS= read -r -d $'\x1e' failure; do
    [ -z "${failure//[[:space:]]/}" ] && continue
    printf "%s%s%s\n" "$_c_red" "$(sed 's/^/      /' <<<"$failure")" "$_c_reset"
  done <"$FAILURE_FILE"

  if [ -s "$stderr_file" ]; then
    printf "%s%s%s\n" "$_c_dim" "$(sed 's/^/      stderr: /' <<<"$(cat "$stderr_file")")" "$_c_reset"
  fi

  echo fail >>"$STATE_DIR/results"
  echo "$fn" >>"$STATE_DIR/failed-names"
  return 0
}

run_test_file() {
  local file=$1
  local filter=${2:-}

  # Each file gets its own subshell so its setup/teardown overrides and helper
  # functions cannot leak into the next file.
  (
    # shellcheck disable=SC1090
    source "$file"

    local fns
    mapfile -t fns < <(declare -F | awk '{print $3}' | grep '^test_' | sort)

    # A filter matches either the test file name or a test function name, so
    # both `runner.sh archive` and `runner.sh round_trip` do what you expect.
    local file_matches=0
    if [ -z "$filter" ] || [[ $(basename "$file") == *"$filter"* ]]; then
      file_matches=1
    fi

    local selected=()
    local fn
    for fn in "${fns[@]}"; do
      if [ "$file_matches" -eq 0 ] && [[ $fn != *"$filter"* ]]; then
        continue
      fi
      selected+=("$fn")
    done

    [ ${#selected[@]} -eq 0 ] && exit 0

    printf "%s%s%s\n" "$_c_cyan" "$(basename "$file")" "$_c_reset"
    for fn in "${selected[@]}"; do
      run_test_function "$fn"
    done
    echo
  )
}

main() {
  local filter=${1:-}

  : >"$STATE_DIR/results"
  : >"$STATE_DIR/failed-names"

  local files
  mapfile -t files < <(find "$TEST_ROOT" -name '*.test.sh' | sort)

  if [ ${#files[@]} -eq 0 ]; then
    echo "No test files found under $TEST_ROOT"
    return 1
  fi

  local file
  for file in "${files[@]}"; do
    run_test_file "$file" "$filter"
  done

  local passed failed skipped
  passed=$(grep -c '^pass$' "$STATE_DIR/results" || true)
  failed=$(grep -c '^fail$' "$STATE_DIR/results" || true)
  skipped=$(grep -c '^skip$' "$STATE_DIR/results" || true)

  printf "%spassed: %d%s  " "$_c_green" "$passed" "$_c_reset"
  if [ "$failed" -gt 0 ]; then
    printf "%sfailed: %d%s  " "$_c_red" "$failed" "$_c_reset"
  else
    printf "failed: 0  "
  fi
  printf "%sskipped: %d%s\n" "$_c_yellow" "$skipped" "$_c_reset"

  if [ "$failed" -gt 0 ]; then
    echo
    printf "%sFailing tests:%s\n" "$_c_red" "$_c_reset"
    sed 's/^/  /' "$STATE_DIR/failed-names"
    return 1
  fi
  return 0
}

main "$@"
