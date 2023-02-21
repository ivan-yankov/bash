# dsc:Backup directory.
# dsc:Files which do not exist in source and exist in target will not be deleted.
# dsc:Comparing is based on file timestamp.
# dsc:Follow links.
# arg:$1 source directory
# arg:$2 destination directory
function backup-update-quick {
  sudo rsync --archive --copy-links "$@"
}
