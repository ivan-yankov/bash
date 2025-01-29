# dsc:Mount external device.
# arg:$1 device file or label
# arg:$2 mount point, if not provided device file or label will be used instead
function mnt {
  is-defined $1 || return 1
  local dev=$1
  local mp=$dev
  is-defined $2 > /dev/null && mp=$2
  local device=$(sudo blkid | grep $dev)
  local m=${device%:*}
  sudo mkdir -p /mnt/$mp

  local fs=$(blkid $m | grep -oP 'TYPE="\K[^"]+')

  case "$fs" in
    "vfat")
      sudo mount -o uid=$USER,gid=$USER $m /mnt/$mp
      ;;
    *)
      sudo mount $m /mnt/$mp
      ;;
  esac
}
