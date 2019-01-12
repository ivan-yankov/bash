function docker-list() {
    echo
    echo "Containers:"
    docker container ls
    
    echo
    echo "Images:"
    docker images
    
    echo
    echo "Volumes: "
    docker volume ls
}