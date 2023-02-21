# dsc:List all docker artifacts.
function docker-list {
  echo
  echo -e "${COLOR_BOLD}Containers:$COLOR_RESET"
  docker ps -a

  echo
  echo -e "${COLOR_BOLD}Images:$COLOR_RESET"
  docker images

  echo
  echo -e "${COLOR_BOLD}Volumes:$COLOR_RESET"
  docker volume ls
}
