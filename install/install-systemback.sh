# dsc:Install systemback backup tool.
function install-systemback {
  sudo add-apt-repository
  sudo apt-get install software-properties-common
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 382003C2C8B7B4AB813E915B14E4942973C62A1B
  sudo add-apt-repository "deb http://ppa.launchpad.net/nemh/systemback/ubuntu xenial main"
  sudo apt update
  sudo apt install systemback
}
