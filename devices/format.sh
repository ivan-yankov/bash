function help-format {
  echo "Format drive."
  echo "Drive must be unmount and specified by path, for example /dev/sdc1"
  echo "Supported file systems are:"
  echo "  ext4: ext4"
  echo "  vfat: FAT32"
  echo "  ntfs: NTFS"
  echo
  echo "Usage: format drive-path file-system label"
}

function format {
  if [  $# -eq 0  ]; then
    help-format
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-format
    return 0
  fi

  local dev=$1
  local fs=$2
  local label=$3

  sudo mkfs.$fs $dev

  case $fs in
    "ext4")
      sudo e2label $dev $label
      ;;
    "vfat")
      sudo mlabel -i $dev ::$label
      ;;
    "ntfs")
      sudo ntfslabel $dev $label
      ;;
    *)
      echo "Unsupported file system $fs"
      ;;
  esac
}
