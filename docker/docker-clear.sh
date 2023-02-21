# dsc:Remove all docker containers, images and volumes.
function docker-clear {
  docker-remove-containers
  docker-remove-images
  docker-remove-volumes
}
