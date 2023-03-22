# dsc:Mount external device.
# arg:$1 device file or label
# arg:$2 mount point, if not provided device file or label will be used instead
function mnt {
  is-defined $1 || return 1
  local dev=$1
  local mp=$dev
  is-defined $2 && mp=$2
  local device=$(sudo blkid | grep $dev)
  local m=${device%:*}
  sudo mkdir -p /mnt/$mp
  sudo mount $m /mnt/$mp
}
