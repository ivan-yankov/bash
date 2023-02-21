# dsc:Unmount external USB disk or flash memory.
# arg:$1 device label
function umnt {
  is-defined $1 || return 1
  sudo umount /mnt/$1
  sudo rmdir /mnt/$1
}
