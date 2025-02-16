function help-docker-install {
  echo "Install Docker Engine."
  echo
  echo "Usage: docker-install os-name"
  echo "  os-name: ubuntu | debian | ..."
}

function docker-install {
  if [  $# -eq 0  ]; then
    help-docker-install
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-docker-install
    return 0
  fi

  local os_name=$1

  sudo apt-get update
  sudo apt-get install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$os_name $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update

  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  sudo groupadd docker
  sudo usermod -aG docker $USER

  echo "Docker installation completed. Reboot the machine."
}
