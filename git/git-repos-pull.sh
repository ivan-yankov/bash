# dsc:Pull git repositories.
# dsc:Should be ran in repositories parent directory.
# env:$COLOR_GREEN console green color
# env:$COLOR_RESET console reset color
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
