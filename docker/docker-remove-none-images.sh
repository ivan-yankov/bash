function docker-remove-none-images {
    # Remove all containers
    docker rm $(docker ps -a -q)
    
    # Remove none images
    docker image prune
    
    docker-list
}