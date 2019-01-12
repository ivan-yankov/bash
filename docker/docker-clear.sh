function docker-clear() {
    # Remove all containers
    docker rm $(docker ps -a -q)
    
    # Remove all images
    docker rmi -f $(docker images -q)
    
    # Remove all volumes
    docker volume rm $(docker volume ls -q)
    
    docker-list
}