function help-backup-sync-checksum {
  echo "Backup directory."
  echo "Files which do not exist in the source and exist in the target will be deleted."
  echo "Comparing is based on file checksum."
  echo "Follow links."
  echo
  echo "Usage: backup-update source-dir destination-dir"
}

function backup-sync-checksum {
  if [  $# -eq 0  ]; then
    help-backup-sync-checksum
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-backup-sync-checksum
    return 0
  fi

  sudo rsync --delete --archive --checksum --copy-links "$@"
}
