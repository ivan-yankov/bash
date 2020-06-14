function docker-list {
  echo
  echo "Containers:"
  echo "-----------"
  docker ps -a

  echo
  echo "Images:"
  echo "-------"
  docker images

  echo
  echo "Volumes:"
  echo "--------"
  docker volume ls
}
