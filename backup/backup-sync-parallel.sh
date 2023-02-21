# dsc:Backup directory in parallel.
# dsc:Files which do not exist in source and exist in target will be deleted.
# dsc:Comparing is based on file checksum.
# dsc:Follow links.
# arg:$1 number of parallel processes
# arg:$2 source directory
# arg:$3 destination directory
function backup-sync-parallel {
  is-defined $1 && is-defined $2 && is-defined $3 || return 1
  local number_of_processes=$1
  local src=$2
  local dest=$3
  local additional=$4
  ls $src | xargs -n1 -P$number_of_processes -I% sudo rsync --delete --archive --checksum --copy-links $additional % $dest
}
