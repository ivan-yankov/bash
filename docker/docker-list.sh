# dsc:List all docker artifacts.
function docker-list {
  printf "${COLOR_CYAN}${COLOR_BOLD}CONTAINERS${COLOR_RESET}"
  echo
  docker ps -a
  echo

  printf "${COLOR_CYAN}${COLOR_BOLD}IMAGES${COLOR_RESET}"
  echo
  docker images
  echo

  printf "${COLOR_CYAN}${COLOR_BOLD}VOLUMES${COLOR_RESET}"
  echo
  docker volume ls
}
