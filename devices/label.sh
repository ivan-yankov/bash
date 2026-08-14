function label {
  cmd-dsc "Set a drive label without formatting it."
  cmd-dsc "The drive must be unmounted and given by path, such as /dev/sdc1."
  cmd-arg device string "Path to the drive"
  cmd-arg filesystem "enum(ext4|vfat|ntfs)" "Filesystem on the drive: ext4, FAT32, NTFS"
  cmd-arg name string "Label to set"
  cmd-example "label /dev/sdc1 ext4 backup"
  cmd-parse "$@" || return $CMD_RC

  case "$ARG_filesystem" in
    ext4) sudo e2label "$ARG_device" "$ARG_name" ;;
    vfat) sudo mlabel -i "$ARG_device" "::$ARG_name" ;;
    ntfs) sudo ntfslabel "$ARG_device" "$ARG_name" ;;
  esac
}
