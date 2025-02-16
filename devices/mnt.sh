function help-mnt {
  echo "Mount external device at $DEVICE_MOUNT_PATH mount point."
  echo
  echo "Usage: mnt device-label"
}

function mnt {
  if [  $# -eq 0  ]; then
    help-mnt
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-mnt
    return 0
  fi

  local device_label=$1
  local device=$(sudo blkid | grep $device_label)
  local mount_device=${device%:*}
  local mount_point=$DEVICE_MOUNT_PATH/$device_label

  if [ -d $mount_point ]; then
    echo "Mount point already exists."
    return 2
  else
    sudo mkdir $mount_point
    local fs=$(blkid $mount_device | grep -oP 'TYPE="\K[^"]+')
    case "$fs" in
      "vfat")
        sudo mount -o uid=$USER,gid=$USER $mount_device $mount_point
        ;;
      *)
        sudo mount $mount_device $mount_point
        ;;
    esac
  fi
}
