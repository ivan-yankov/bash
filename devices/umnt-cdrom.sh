# dsc:Unmount cdrom.
function umnt-cdrom {
  sudo umount /mnt/cdrom
  sudo rmdir /mnt/cdrom
}
