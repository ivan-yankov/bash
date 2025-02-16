function help-backup-sync-parallel {
  echo "Backup directory parallel."
  echo "Files which do not exist in the source and exist in the target will be deleted."
  echo "Comparing is based on file timestamp."
  echo "Follow links."
  echo
  echo "Usage: backup-update source-dir destination-dir"
}

function backup-sync-parallel {
  if [  $# -eq 0  ]; then
    help-backup-sync-parallel
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-backup-sync-parallel
    return 0
  fi

  local number_of_processes=$1
  local src=$2
  local dest=$3
  local additional_arguments=$4

  ls $src | xargs -n1 -P$number_of_processes -I% sudo rsync --delete --archive --checksum --copy-links $additional_arguments % $dest
}
