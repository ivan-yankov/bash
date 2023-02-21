# dsc:Mount external USB disk or flash memory.
# arg:$1 device label
function mnt {
  is-defined $1 || return 1
  local label=$1
  local device=$(sudo blkid | grep $label)
  local m=${device%:*}
  sudo mkdir -p /mnt/$label
  sudo mount $m /mnt/$label
}
