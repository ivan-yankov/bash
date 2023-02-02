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
  local src=$1
  local dest=$2
  local number_of_processes=$3
  local exclude=$4
  ls $src | xargs -n1 -P$number_of_processes -I% /bin/bash -c "source $BASH_SOURCE && backup-sync $exclude % $dest"
}
