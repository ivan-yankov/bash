# dsc:Backup directory.
# dsc:Files which do not exist in source and exist in target will not be deleted.
# dsc:Comparing is based on file checksum.
# dsc:Follow links.
# arg:$1 source directory
# arg:$2 destination directory
function backup-update {
  sudo rsync --archive --checksum --copy-links "$@"
}
