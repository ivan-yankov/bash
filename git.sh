function git-repos-status {
  is-defined $COLOR_GREEN && is-defined $COLOR_RESET || return 1

  for d in */; do
    echo -e "$COLOR_GREEN$d$COLOR_RESET"
    cd $d
    git status
    cd ..
    echo
  done
}

function git-repos-pull {
  is-defined $COLOR_GREEN && is-defined $COLOR_RESET || return 1

  for d in */; do
    echo -e "$COLOR_GREEN$d$COLOR_RESET"
    cd $d
    git pull -p
    cd ..
    echo
  done
}
