function install-systemback {
  cmd-dsc "Install the systemback backup tool."
  cmd-example "install-systemback"
  cmd-parse "$@" || return $CMD_RC

  sudo apt-get install -y software-properties-common
  sudo apt-key adv --keyserver keyserver.ubuntu.com \
    --recv-keys 382003C2C8B7B4AB813E915B14E4942973C62A1B
  sudo add-apt-repository "deb http://ppa.launchpad.net/nemh/systemback/ubuntu xenial main"
  sudo apt update
  sudo apt install -y systemback
}
