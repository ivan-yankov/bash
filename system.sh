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

function man-pack-list {
  echo "Manually installed packages without dependencies:"
  echo "-------------------------------------------------"
  comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)
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

  sudo rsync --delete --inplace -a $src/ $dest
}
