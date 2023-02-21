# dsc:Remove all docker images.
function docker-remove-images {
  docker rmi -f $(docker images -q)
}
