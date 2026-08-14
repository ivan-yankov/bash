function docker-uninstall {
  cmd-dsc "Uninstall Docker Engine and delete its data directories."
  cmd-example "docker-uninstall"
  cmd-parse "$@" || return $CMD_RC

  sudo apt-get purge -y docker-ce docker-ce-cli containerd.io \
    docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
  sudo rm -rf /var/lib/docker
  sudo rm -rf /var/lib/containerd
}
