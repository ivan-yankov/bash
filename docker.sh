function docker-install {
  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

  sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'

  sudo apt update

  sudo apt install linux-image-generic linux-image-extra-virtual

  sudo apt install docker-engine

  sudo usermod -a -G docker $USER

  echo
  echo "Docker installation completed"
  echo "Reboot the system"
}

function docker-uninstall {
  sudo apt remove -y --purge docker-engine
  sudo apt autoremove
  sudo apt autoclean

  sudo rm -rf /var/lib/docker
}

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

function docker-clear {
  # Remove all containers
  docker rm $(docker ps -a -q)

  # Remove all images
  docker rmi -f $(docker images -q)

  # Remove all volumes
  docker volume rm $(docker volume ls -q)

  docker-list
}

function docker-remove-none-images {
  docker image prune
  docker-list
}
