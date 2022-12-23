function clean-system {
  sudo apt autoremove
  sudo apt autoclean
  sudo apt clean
  sudo apt purge $(dpkg -l | grep '^rc' | awk '{print $2}')
}

function diffdir {
  is-defined $1 && is-defined $2 || return 1
  src=$1
  dest=$2
  diff -qr $src $dest
}

function own {
  is-defined $1 || return 1
  file=$1
  sudo chown --recursive $USER $file
}

function grant-dir-access {
  is-defined $1 || return 1
  sudo chmod u+rx,go-w $1
}

function size {
  is-defined $1 || return 1
  file=$1
  sudo du -sh $file
}

function syncdir {
  is-defined $1 && is-defined $2 || return 1
  src=$1
  dest=$2
  sudo rsync --delete --inplace --checksum -a $src/ $dest
}

function syncdir-quick {
  is-defined $1 && is-defined $2 || return 1
  src=$1
  dest=$2
  sudo rsync --delete --inplace -a $src/ $dest
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
