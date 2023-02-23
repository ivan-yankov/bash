# dsc:Install and configure asunder audio ripping software.
function install-asunder {
  sudo apt install asunder

  local cfg=~/.config/asunder
  mkdir -p $cfg
  cp $(dirname $BASH_SOURCE)/asunder $cfg
}
