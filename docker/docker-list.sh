function docker-list {
    echo
    echo "Containers:"
    docker ps -a
    
    echo
    echo "Images:"
    docker images
    
    echo
    echo "Volumes: "
    docker volume ls
}