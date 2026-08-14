function mnt {
  cmd-dsc "Mount an external device by its label, under DEVICE_MOUNT_PATH."
  cmd-arg device-label string "Label of the device to mount"
  cmd-env DEVICE_MOUNT_PATH "Directory the mount points are created under"
  cmd-example "mnt backup"
  cmd-parse "$@" || return $CMD_RC

  local device mount_device mount_point fs
  device=$(sudo blkid | grep "$ARG_device_label")
  mount_device=${device%:*}
  mount_point=$DEVICE_MOUNT_PATH/$ARG_device_label

  if [ -d "$mount_point" ]; then
    echo "Mount point already exists." >&2
    return 2
  fi

  sudo mkdir "$mount_point"
  fs=$(blkid "$mount_device" | grep -oP 'TYPE="\K[^"]+')
  case "$fs" in
    vfat) sudo mount -o "uid=$USER,gid=$USER" "$mount_device" "$mount_point" ;;
    *)    sudo mount "$mount_device" "$mount_point" ;;
  esac
}
