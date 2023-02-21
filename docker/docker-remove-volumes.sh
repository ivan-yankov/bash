# dsc:Remove all docker volumes.
function docker-remove-volumes {
  docker volume rm $(docker volume ls -q)
}
