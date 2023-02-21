# dsc:Install audacity.
function install-audacity {
  sudo add-apt-repository ppa:ubuntuhandbook1/audacity
  sudo apt update
  sudo apt install audacity
}
