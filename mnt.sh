function mnt-drive {
  is-defined $1 || return 1
  local label=$1
  local device=$(sudo blkid | grep $label)
  local m=${device%:*}
  sudo mkdir -p /media/$USER/$label
  sudo mount $m /media/$USER/$label
}

function umnt-drive {
  is-defined $1 || return 1
  sudo umount /media/$USER/$1
  sudo rmdir /media/$USER/$1
}
