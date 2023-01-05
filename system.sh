function clean-system {
  sudo apt autoremove
  sudo apt autoclean
  sudo apt clean
  sudo apt purge $(dpkg -l | grep '^rc' | awk '{print $2}')
}

function own {
  is-defined $1 || return 1
  sudo chown --recursive $USER $1
}

function grant-dir-access {
  is-defined $1 || return 1
  sudo chmod u+rx,go-w $1
}

function size {
  is-defined $1 || return 1
  sudo du -sh $1
}

function diffdir {
  is-defined $1 && is-defined $2 || return 1
  diff -qr $1 $2
}

function backup-update-quick {
  is-defined $1 && is-defined $2 || return 1
  local src=$1
  local dest=$2
  local exclude=$3
  sudo rsync $exclude --archive $src/ $dest
}

function backup-update {
  is-defined $1 && is-defined $2 || return 1
  local src=$1
  local dest=$2
  local exclude=$3
  sudo rsync $exclude --archive --checksum $src/ $dest
}

function backup-sync-quick {
  is-defined $1 && is-defined $2 || return 1
  local src=$1
  local dest=$2
  local exclude=$3
  sudo rsync $exclude --delete --archive $src/ $dest
}

function backup-sync {
  is-defined $1 && is-defined $2 || return 1
  local src=$1
  local dest=$2
  local exclude=$3
  sudo rsync $exclude --delete --archive --checksum $src/ $dest
}

function base64-encode {
  is-defined $1 || return 1
  echo -n $1 | base64
}

function base64-decode {
  is-defined $1 || return 1
  echo $1 | base64 --decode
  echo
}

function dvd-copy {
  is-defined $1 || return 1  
  dest=~/temp/$1
  mkdir -p $dest
  sudo cp -r ./VIDEO_TS $dest
  sudo chmod +rwx $dest/VIDEO_TS/
}

function external-drive-permissions {
  is-defined $1 || return 1
  sudo chmod -R ugo+rwx $1
}

function mount-drive {
  is-defined $1 || return 1
  local label=$1
  local device=$(sudo blkid | grep $label)
  local m=${device%:*}
  sudo mkdir -p /media/$USER/$label
  sudo mount $m /media/$USER/$label
}

function umount-drive {
  is-defined $1 || return 1
  sudo umount /media/$USER/$1
  sudo rmdir /media/$USER/$1
}
