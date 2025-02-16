function help-umnt {
  echo "Unmount external device mounted at $DEVICE_MOUNT_PATH mount point."
  echo
  echo "Usage: umnt mount-point [force]"
}

function umnt {
  if [  $# -eq 0  ]; then
    help-umnt
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-umnt
    return 0
  fi

  local mount_point=$DEVICE_MOUNT_PATH/$1
  local force=$2

  if [ -n "$2" ] && [ "$2" = "force" ]; then
    sudo fuser -km $mount_point
  fi

  sudo umount $mount_point
  sudo rmdir $mount_point
}
