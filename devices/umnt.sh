function umnt {
  cmd-dsc "Unmount a device mounted under DEVICE_MOUNT_PATH and remove its"
  cmd-dsc "mount point."
  cmd-arg mount-point-name string "Name of the mount point to remove"
  cmd-flag -f --force "Kill the processes still using the mount point first"
  cmd-env DEVICE_MOUNT_PATH "Directory the mount points are created under"
  cmd-example "umnt backup"
  cmd-example "umnt backup --force"
  cmd-parse "$@" || return $CMD_RC

  local mount_point=$DEVICE_MOUNT_PATH/$ARG_mount_point_name

  if [ "$ARG_force" == "true" ]; then
    sudo fuser -km "$mount_point"
  fi

  sudo umount "$mount_point" && sudo rmdir "$mount_point"
}
