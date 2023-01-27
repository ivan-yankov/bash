function mnt {
  is-defined $1 || return 1
  local label=$1
  local device=$(sudo blkid | grep $label)
  local m=${device%:*}
  sudo mkdir -p /mnt/$label
  sudo mount $m /mnt/$label
}

function umnt {
  is-defined $1 || return 1
  sudo umount /mnt/$1
  sudo rmdir /mnt/$1
}
