function clean-system {
  sudo apt autoremove
  sudo apt autoclean
  sudo apt clean
  sudo apt purge $(dpkg -l | grep '^rc' | awk '{print $2}')
}

function create-shortcut {
	if [ "$#" != "3" ]; then
    echo "create-shortcut <shortcut-name> <execution-file> <icon-file>"
    return
  fi

  shortcut_name=$1
  execution_file=$2
  icon_file=$3

  file=~/Desktop/$shortcut_name.desktop

  echo "[Desktop Entry]" >> $file
  echo "Name="$shortcut_name >> $file
  echo "Comment=" >> $file
  echo "Exec="$execution_file >> $file
  echo "Icon="$icon_file >> $file
  echo "Terminal=false" >> $file
  echo "Type=Application" >> $file

  chmod +x $file
  chown $USER $file
}

function diffdir {
  if [ "$#" != "2" ]; then
    echo "diffdir <src> <dest>"
    return
  fi

  src=$1
  dest=$2

  diff -qr $src $dest
}

function own {
  if [ "$#" != "1" ]; then
    echo "own <file>"
    return
  fi

  file=$1

  sudo chown --recursive $USER $file
}

function size {
  if [ "$#" != "1" ]; then
    echo "size <file>"
    return
  fi

  file=$1

  sudo du -sh $file
}

function syncdir {
  if [ "$#" != "2" ]; then
    echo "syncdir <src> <dest>"
    return
  fi

  src=$1
  dest=$2

  sudo rsync --delete --inplace --checksum -a $src/ $dest
}

function syncdir-quick {
  if [ "$#" != "2" ]; then
    echo "syncdir <src> <dest>"
    return
  fi

  src=$1
  dest=$2

  sudo rsync --delete --inplace -a $src/ $dest
}

function base64-encode {
  echo -n $1 | base64
}

function base64-decode {
  echo $1 | base64 --decode
  echo
}

function dvd-copy {
  if [ "$#" != "1" ]; then
    echo "dvd-copy <dest>"
    return
  fi
  
  dest=~/temp/$1
  
  mkdir -p $dest
  sudo cp -r ./VIDEO_TS $dest
  sudo chmod +rwx $dest/VIDEO_TS/
}

function external-drive-permissions {
  if [ "$#" != "1" ]; then
    echo "external-drive-permissions <path>"
    return
  fi
  sudo chmod -R ugo+rwx $1
}

function mount-usb {
  if [ "$#" != "1" ]; then
    echo "mount-usb <label>"
    return
  fi

  local label=$1
  local device=$(sudo blkid | grep $label)
  local m=${device%:*}
  sudo mkdir -p /media/$USER/$label
  sudo mount $m /media/$USER/$label
}

function umount-usb {
  if [ "$#" != "1" ]; then
    echo "umount-usb <label>"
    return
  fi

  sudo umount /media/$USER/$1
  sudo rmdir /media/$USER/$1
}
