function install-asunder {
  cmd-dsc "Install the asunder audio ripper and copy its configuration."
  cmd-example "install-asunder"
  cmd-parse "$@" || return $CMD_RC

  sudo apt install -y asunder

  local cfg=~/.config/asunder
  local src
  src=$(dirname "${BASH_SOURCE[0]}")

  mkdir -p "$cfg"
  cp "$src/asunder" "$cfg"
}
