# dsc:Show git repositories status.
# dsc:Should be ran in repositories parent directory.
# env:$COLOR_GREEN console green color
# env:$COLOR_RESET console reset color
function git-repos-status {
  is-defined $COLOR_GREEN && is-defined $COLOR_RESET || return 1

  for d in */; do
    printf "${COLOR_GREEN}${d}${COLOR_RESET}\n"
    cd $d
    git status
    cd ..
    echo
  done
}
