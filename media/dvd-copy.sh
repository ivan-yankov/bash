function help-dvd-copy {
  echo "Copy DVD disc files to a specified subdirectory of the current one."
  echo "Mounts optical drive to /mnt/cdrom."
  echo
  echo "Usage: dvd-copy dest-dir"
}

function dvd-copy {
  if [  $# -eq 0  ]; then
    help-dvd-copy
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-dvd-copy
    return 0
  fi

  mnt-cdrom

  local src=/mnt/cdrom
  local dest=$1
  mkdir -p $dest
  sudo cp -r $src/VIDEO_TS $dest
  sudo chmod +rwx $dest/VIDEO_TS/

  umnt-cdrom
}
