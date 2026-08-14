function docker-list {
  cmd-dsc "List all docker containers, images and volumes."
  cmd-example "docker-list"
  cmd-parse "$@" || return $CMD_RC

  printf '%s%sCONTAINERS%s\n' "$COLOR_CYAN" "$COLOR_BOLD" "$COLOR_RESET"
  docker ps -a
  echo

  printf '%s%sIMAGES%s\n' "$COLOR_CYAN" "$COLOR_BOLD" "$COLOR_RESET"
  docker images
  echo

  printf '%s%sVOLUMES%s\n' "$COLOR_CYAN" "$COLOR_BOLD" "$COLOR_RESET"
  docker volume ls
}
