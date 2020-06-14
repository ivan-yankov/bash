function docker-remove-none-images {
  docker image prune
  docker-list
}
