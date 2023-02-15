function size {
  is-defined $1 || return 1
  sudo du -sh $1
}

function own {
  is-defined $1 || return 1
  sudo chown --recursive $USER $1
}

function grant-access-dir {
  is-defined $1 || return 1
  sudo chmod u+rx,go-w $1
}

function grant-access-external-drive {
  is-defined $1 || return 1
  sudo chmod -R ugo+rwx $1
}

function title {
  is-defined $1 || return 1
  echo -ne "\033]30;$1\007"
}
