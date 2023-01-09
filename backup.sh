function backup-update-quick {
  sudo rsync --archive --copy-links "$@"
}

function backup-update {
  sudo rsync --archive --checksum --copy-links "$@"
}

function backup-sync-quick {
  sudo rsync --delete --archive --copy-links "$@"
}

function backup-sync {
  sudo rsync --delete --archive --checksum --copy-links "$@"
}
