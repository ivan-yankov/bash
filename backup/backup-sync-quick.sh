# dsc:Backup directory.
# dsc:Files which do not exist in source and exist in target will be deleted.
# dsc:Comparing is based on timestamp.
# dsc:Follow links.
# arg:$1 source directory
# arg:$2 destination directory
function backup-sync-quick {
  sudo rsync --delete --archive --copy-links "$@"
}
