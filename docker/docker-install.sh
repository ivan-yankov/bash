# dsc:Download and install docker.
function docker-install {
  local dest=/tmp

  local release=$(lsb_release -cs)
  local arch=$(dpkg --print-architecture)
  local url="https://download.docker.com/linux/ubuntu/dists/$release/pool/stable/amd64"

  local container_io_version="1.6.9-1"
  local docker_ce_version="23.0.1-1~ubuntu.22.04~jammy"
  local docker_ce_cli_version="23.0.1-1~ubuntu.22.04~jammy"
  local docker_buildx_plugin_version="0.10.2-1~ubuntu.22.04~jammy"
  local docker_compose_plugin_version="2.16.0-1~ubuntu.22.04~jammy"

  local f1=containerd.io_${container_io_version}_${arch}.deb
  local f2=docker-ce_${docker_ce_version}_${arch}.deb
  local f3=docker-ce-cli_${docker_ce_cli_version}_${arch}.deb
  local f4=docker-buildx-plugin_${docker_buildx_plugin_version}_${arch}.deb
  local f5=docker-compose-plugin_${docker_compose_plugin_version}_${arch}.deb

  curl -L $url/$f1 -o $dest/$f1
  curl -L $url/$f2 -o $dest/$f2
  curl -L $url/$f3 -o $dest/$f3
  curl -L $url/$f4 -o $dest/$f4
  curl -L $url/$f5 -o $dest/$f5

  sudo dpkg -i $dest/$f1 $dest/$f2 $dest/$f3 $dest/$f4 $dest/$f5

  rm $f1 $f2 $f3 $f4 $f5

  sudo groupadd docker
  sudo usermod -aG docker $USER

  read -p "Docker installation completed. Reboot now (y/n): " rb
  if [ $rb == "y" ]; then
    reboot
  fi
}
