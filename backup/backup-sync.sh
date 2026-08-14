function backup-sync {
  cmd-dsc "Back up a directory with rsync, following symbolic links."
  cmd-dsc "Files present in the target but not in the source are deleted."
  cmd-dsc "Comparison is based on file timestamp."
  cmd-arg source dir "Directory to copy from"
  cmd-arg target string "Directory to copy into"
  cmd-example "backup-sync ~/data/ /mnt/backup/data"
  cmd-parse "$@" || return $CMD_RC

  sudo rsync --delete --archive --copy-links "$ARG_source" "$ARG_target"
}
