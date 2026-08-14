function install-nodejs {
  cmd-dsc "Install Node.js from the NodeSource repository."
  cmd-example "install-nodejs"
  cmd-parse "$@" || return $CMD_RC

  curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
  sudo apt update
  sudo apt install -y nodejs
}
