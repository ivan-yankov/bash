# Behaviour of the rsync wrappers.
#
# These commands are the reason the package exists on a machine, and they run
# rsync through sudo, so the checks here run the real thing rather than a stub:
# what matters is that the arguments the wrapper builds reach rsync in the
# right order, above all the options handed through after '--'.

setup() {
  load_commands

  mkdir -p src/inner
  echo "one" > src/one.txt
  echo "two" > src/inner/two.txt
  echo "lock" > src/session.lock
  echo "lock" > src/inner/other.lock

  mkdir -p dst
}

teardown() {
  # rsync ran as root, so give the sandbox back before the runner deletes it.
  sudo -n chown -R "$(id -u):$(id -g)" . 2>/dev/null || true
}

# The commands need passwordless sudo, which the test container has and a
# developer machine may not.
need_sudo() {
  sudo -n true 2>/dev/null && return 0
  skip "no passwordless sudo"
  return 1
}

test_backup_sync_copies_the_tree() {
  need_sudo || return 0

  run backup-sync src/ dst
  assert_rc 0 "$rc"
  assert_file dst/one.txt
  assert_file dst/inner/two.txt
}

test_backup_sync_passes_options_through_to_rsync() {
  need_sudo || return 0

  run backup-sync src/ dst -- --exclude '*.lock'
  assert_rc 0 "$rc"
  assert_file dst/one.txt
  assert_file dst/inner/two.txt
  [ -e dst/session.lock ] && fail "excluded file was copied: dst/session.lock"
  [ -e dst/inner/other.lock ] && fail "excluded file was copied: dst/inner/other.lock"
  return 0
}

test_backup_sync_accepts_several_pass_through_options() {
  need_sudo || return 0

  run backup-sync src/ dst -- --exclude '*.lock' --exclude inner
  assert_rc 0 "$rc"
  assert_file dst/one.txt
  [ -e dst/inner ] && fail "excluded directory was copied: dst/inner"
  [ -e dst/session.lock ] && fail "excluded file was copied: dst/session.lock"
  return 0
}

test_backup_sync_deletes_what_the_source_no_longer_has() {
  need_sudo || return 0

  echo "stale" > dst/gone.txt

  run backup-sync src/ dst
  assert_rc 0 "$rc"
  [ -e dst/gone.txt ] && fail "backup-sync kept a file missing from the source"
  return 0
}

test_backup_update_keeps_what_the_source_no_longer_has() {
  need_sudo || return 0

  echo "stale" > dst/gone.txt

  run backup-update src/ dst
  assert_rc 0 "$rc"
  assert_file dst/gone.txt
  assert_file dst/one.txt
}

test_backup_update_passes_options_through_to_rsync() {
  need_sudo || return 0

  run backup-update src/ dst -- --exclude '*.lock'
  assert_rc 0 "$rc"
  assert_file dst/one.txt
  [ -e dst/session.lock ] && fail "excluded file was copied: dst/session.lock"
  return 0
}

test_backup_sync_checksum_passes_options_through_to_rsync() {
  need_sudo || return 0

  run backup-sync-checksum src/ dst -- --exclude '*.lock'
  assert_rc 0 "$rc"
  assert_file dst/one.txt
  [ -e dst/session.lock ] && fail "excluded file was copied: dst/session.lock"
  return 0
}

test_backup_update_checksum_passes_options_through_to_rsync() {
  need_sudo || return 0

  run backup-update-checksum src/ dst -- --exclude '*.lock'
  assert_rc 0 "$rc"
  assert_file dst/one.txt
  [ -e dst/session.lock ] && fail "excluded file was copied: dst/session.lock"
  return 0
}

# The parse layer, which needs no sudo because the body never runs.

test_backup_sync_rejects_an_rsync_option_given_before_the_separator() {
  run backup-sync --exclude '*.lock' src/ dst
  assert_rc_nonzero "$rc"
  assert_contains "$output" "unknown option [--exclude]"
}

test_backup_sync_says_where_pass_through_options_go() {
  run backup-sync --exclude '*.lock' src/ dst
  assert_contains "$output" "must come after --"
}

test_backup_sync_help_documents_the_pass_through_argument() {
  run backup-sync -h
  assert_rc 0 "$rc"
  assert_contains "$output" "[rsync-options...]"
}
