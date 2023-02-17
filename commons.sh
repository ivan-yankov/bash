function size {
  is-defined $1 || return 1
  sudo du -sh $1
}

function own {
  is-defined $1 || return 1
  sudo chown --recursive $USER $1
}

function grant-access {
  is-defined $1 || return 1
  sudo chmod -R a+rw $1
}

function title {
  is-defined $1 || return 1
  echo -ne "\033]30;$1\007"
}
