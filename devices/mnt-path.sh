function mnt-path {
  cmd-dsc "Mount a device given by path, under DEVICE_MOUNT_PATH."
  cmd-arg device string "Path to the device, such as /dev/sdc1"
  cmd-arg mount-point-name string "Name of the mount point to create"
  cmd-env DEVICE_MOUNT_PATH "Directory the mount points are created under"
  cmd-example "mnt-path /dev/sdc1 backup"
  cmd-parse "$@" || return $CMD_RC

  local mount_point=$DEVICE_MOUNT_PATH/$ARG_mount_point_name

  if [ -d "$mount_point" ]; then
    echo "Mount point already exists." >&2
    return 2
  fi

  sudo mkdir "$mount_point"
  sudo mount "$ARG_device" "$mount_point"
}
