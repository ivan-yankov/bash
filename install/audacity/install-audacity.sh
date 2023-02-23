# dsc:Install and configure audacity.
function install-audacity {
  sudo add-apt-repository ppa:ubuntuhandbook1/audacity
  sudo apt update
  sudo apt install audacity

  local cfg=~/.audacity-data
  local src=$(dirname $BASH_SOURCE)

  cp $src/audacity.cfg $cfg

  mkdir -p $cfg/Macros
  cp $src/FLAC_Normalize.txt $cfg/Macros
}
