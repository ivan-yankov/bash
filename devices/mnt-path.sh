function help-mnt-path {
  echo "Mount external device at $DEVICE_MOUNT_PATH mount point."
  echo
  echo "Usage: mnt device-path mount-point"
}

function mnt-path {
  if [  $# -eq 0  ]; then
    help-mnt-path
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-mnt-path
    return 0
  fi

  local mount_path=$1
  local mount_point_name=$2
  local mount_point=$DEVICE_MOUNT_PATH/$mount_point_name

  if [ -d $mount_point ]; then
    echo "Mount point already exists."
    return 2
  else
    sudo mkdir $mount_point
    sudo mount $mount_path $mount_point
  fi
}
