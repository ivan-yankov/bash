function backup-sync {
  cmd-dsc "Back up a directory with rsync, following symbolic links."
  cmd-dsc "Files present in the target but not in the source are deleted."
  cmd-dsc "Comparison is based on file timestamp."
  cmd-arg source dir "Directory to copy from"
  cmd-arg target string "Directory to copy into"
  cmd-arg rsync-options string... "Extra options passed through to rsync, after --"
  cmd-example "backup-sync ~/data/ /mnt/backup/data"
  cmd-example "backup-sync ~/data/ /mnt/backup/data -- --exclude '*.lock'"
  cmd-parse "$@" || return $CMD_RC

  sudo rsync --delete --archive --copy-links \
    ${ARG_rsync_options[@]+"${ARG_rsync_options[@]}"} "$ARG_source" "$ARG_target"
}
