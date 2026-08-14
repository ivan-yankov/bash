function backup-sync-checksum {
  cmd-dsc "Back up a directory with rsync, following symbolic links."
  cmd-dsc "Files present in the target but not in the source are deleted."
  cmd-dsc "Comparison is based on file checksum."
  cmd-arg source dir "Directory to copy from"
  cmd-arg target string "Directory to copy into"
  cmd-example "backup-sync-checksum ~/data/ /mnt/backup/data"
  cmd-parse "$@" || return $CMD_RC

  sudo rsync --delete --archive --checksum --copy-links "$ARG_source" "$ARG_target"
}
