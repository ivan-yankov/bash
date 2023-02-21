# dsc:Uninstall docker.
function docker-uninstall {
  sudo apt purge docker-ce docker-ce-cli containerd.io
  sudo rm -rf /var/lib/docker
}
