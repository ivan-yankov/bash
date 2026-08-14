function install-mc {
  cmd-dsc "Install Midnight Commander and copy its configuration."
  cmd-dsc "Any existing mc.ext is kept as mc.ext.bak."
  cmd-example "install-mc"
  cmd-parse "$@" || return $CMD_RC

  sudo apt install -y mc

  local cfg=~/.config/mc
  local src
  src=$(dirname "${BASH_SOURCE[0]}")

  mkdir -p "$cfg"
  cp "$src/ini" "$cfg"
  [ -f "$cfg/mc.ext" ] && cp "$cfg/mc.ext" "$cfg/mc.ext.bak"
  cp "$src/mc.ext" "$cfg"
  cp "$src/panels.ini" "$cfg"
}
