# dsc:Mount cdrom as /mnt/cdrom.
function mnt-cdrom {
  local mp=/mnt/cdrom
  sudo mkdir -p /mnt/$mp
  sudo mount /dev/sr0 /mnt/$mp
}
