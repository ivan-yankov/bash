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

function backup-sync-parallel {
  is-defined $1 && is-defined $2 && is-defined $3 || return 1
  local number_of_processes=$1
  local src=$2
  local dest=$3
  local exclude=$4
  ls $src | xargs -n1 -P$number_of_processes -I% sudo rsync --delete --archive --checksum --copy-links $exclude $src $dest
}
