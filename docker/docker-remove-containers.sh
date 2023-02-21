# dsc:Remove all docker containers.
function docker-remove-containers {
  docker rm $(docker ps -a -q)
}
