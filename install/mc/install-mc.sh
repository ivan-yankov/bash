# dsc:Install and configure MidnightCommander.
function install-mc {
  sudo apt install mc

  local cfg=~/.config/mc

  mkdir -p $cfg
  local src=$(dirname $BASH_SOURCE)
  cp $src/ini $cfg
  cp $cfg/mc.ext $cfg/mc.ext.bak
  cp $src/mc.ext $cfg
  cp $src/panels.ini $cfg
}
