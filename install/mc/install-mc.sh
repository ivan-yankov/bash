# dsc:Install and configure MidnightCommander.
function install-mc {
  sudo apt install mc

  local cfg=~/.config/mc

  mkdir -p $cfg
  if [ -f $cfg/mc.ext  ]; then
    mv $cfg/mc.ext $cfg/mc.ext.original
  fi

  local src=$(dirname $BASH_SOURCE)
  cp $src/ini $cfg
  cp $src/mc.ext $cfg
  cp $src/panels.ini $cfg
}
