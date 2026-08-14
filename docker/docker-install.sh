function docker-install {
  cmd-dsc "Install Docker Engine from the official Docker apt repository."
  cmd-dsc "A reboot is needed afterwards for the group change to take effect."
  cmd-arg distribution "enum(ubuntu|debian)" "Distribution to install for"
  cmd-example "docker-install ubuntu"
  cmd-parse "$@" || return $CMD_RC

  sudo apt-get update
  sudo apt-get install -y ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL "https://download.docker.com/linux/$ARG_distribution/gpg" \
    -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  local arch codename
  arch=$(dpkg --print-architecture)
  codename=$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")

  echo "deb [arch=$arch signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$ARG_distribution $codename stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update

  sudo apt-get install -y docker-ce docker-ce-cli containerd.io \
    docker-buildx-plugin docker-compose-plugin

  sudo groupadd -f docker
  sudo usermod -aG docker "$USER"

  echo "Docker installation completed. Reboot the machine."
}
