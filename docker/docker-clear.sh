function docker-clear {
  cmd-dsc "Remove all docker containers, images and volumes."
  cmd-example "docker-clear"
  cmd-parse "$@" || return $CMD_RC

  docker-remove-containers
  docker-remove-images
  docker-remove-volumes
}
