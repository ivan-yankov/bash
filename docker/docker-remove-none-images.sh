# dsc:Remove all docker untagged images.
function docker-remove-none-images {
  docker image prune
}
