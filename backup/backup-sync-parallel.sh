function backup-sync-parallel {
  cmd-dsc "Back up a directory with rsync, one process per top level entry."
  cmd-dsc "Files present in the target but not in the source are deleted."
  cmd-dsc "Comparison is based on file checksum. Symbolic links are followed."
  cmd-arg processes int "Number of rsync processes to run at once"
  cmd-arg source dir "Directory to copy from"
  cmd-arg target string "Directory to copy into"
  cmd-arg rsync-options string... "Extra options passed through to rsync, after --"
  cmd-example "backup-sync-parallel 4 ~/data/ /mnt/backup/data"
  cmd-example "backup-sync-parallel 4 ~/data/ /mnt/backup/data -- --exclude '*.lock'"
  cmd-parse "$@" || return $CMD_RC

  ls "$ARG_source" | xargs -n1 "-P$ARG_processes" -I% \
    sudo rsync --delete --archive --checksum --copy-links \
      ${ARG_rsync_options[@]+"${ARG_rsync_options[@]}"} "%" "$ARG_target"
}
