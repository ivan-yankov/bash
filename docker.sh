function docker-install {
  # update the apt package index and install packages to allow apt to use a repository over https
  sudo apt update
  sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

  # add docker official gpg key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  # setup stable repositopry
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

  # install docker engine
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io

  sudo usermod -a -G docker $USER

  echo
  echo "Docker installation completed"
  echo "Reboot the system"
}

function docker-uninstall {
  sudo apt purge docker-ce docker-ce-cli containerd.io
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
}

function docker-remove-none-images {
  docker image prune
  docker-list
}
