function help-backup-update-checksum {
  echo "Backup directory."
  echo "Files which do not exist in the source and exist in the target will not be deleted."
  echo "Comparing is based on file checksum."
  echo "Follow links."
  echo
  echo "Usage: backup-update source-dir destination-dir"
}

function backup-update-checksum {
  if [  $# -eq 0  ]; then
    help-backup-update-checksum
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-backup-update-checksum
    return 0
  fi

  sudo rsync --archive --checksum --copy-links "$@"
}
