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

function docker-remove-containers {
  docker rm $(docker ps -a -q)
}

function docker-remove-images {
  docker rmi -f $(docker images -q)
}

function docker-remove-none-images {
  docker image prune
}

function docker-remove-volumes {
  docker volume rm $(docker volume ls -q)
}

function docker-clear {
  docker-remove-containers
  docker-remove-images
  docker-remove-volumes
}

function docker-save-images {
  is-defined $1 || return 1

  local dir=$1

  IFS=$'\n' imgs=($(docker images))

  mkdir -p $dir

  for img in "${imgs[@]:1}"; do
    local repo=$(echo $img | awk '{ print $1 }')
    local tag=$(echo $img | awk '{ print $2 }')
    local id=$(echo $img | awk '{ print $3 }')
    echo "Save image: $img"
    docker save --output $dir/$id.tar $id
    echo $repo > $dir/$id.repository
    echo $tag > $dir/$id.tag
  done
}

function docker-load-images {
  is-defined $1 || return 1

  local dir=$1

  for f in $dir/*.tar; do
    local id=$(file-name-without-ext $f)
    local repo=$(cat $id.repository)
    local tag=$(cat $id.tag)

    echo "Load image: $id"
    docker load --input $f

    echo "Tag image: $id -> $repo:$tag"
    docker tag $id $repo:$tag
  done
}
