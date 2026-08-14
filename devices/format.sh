function format {
  cmd-dsc "Format a drive and set its label."
  cmd-dsc "The drive must be unmounted and given by path, such as /dev/sdc1."
  cmd-dsc "This destroys everything on the drive."
  cmd-arg device string "Path to the drive"
  cmd-arg filesystem "enum(ext4|vfat|ntfs)" "Filesystem to create: ext4, FAT32, NTFS"
  cmd-arg name string "Label to set after formatting"
  cmd-example "format /dev/sdc1 ext4 backup"
  cmd-parse "$@" || return $CMD_RC

  sudo "mkfs.$ARG_filesystem" "$ARG_device" || return

  label "$ARG_device" "$ARG_filesystem" "$ARG_name"
}
