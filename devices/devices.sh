function devices {
  cmd-dsc "List the block devices connected to the computer."
  cmd-example "devices"
  cmd-parse "$@" || return $CMD_RC

  sudo blkid
}
