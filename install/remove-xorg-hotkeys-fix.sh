function remove-xorg-hotkeys-fix {
  cmd-dsc "Remove the xorg hotkeys fix and its PPA."
  cmd-example "remove-xorg-hotkeys-fix"
  cmd-parse "$@" || return $CMD_RC

  sudo apt install -y ppa-purge
  sudo rm -f /etc/apt/preferences.d/pin-xorg-hotkeys
  sudo ppa-purge ppa:nrbrtx/xorg-hotkeys -y
  sudo apt-get update
  sudo apt-get remove -y xserver-common xserver-xorg-core xserver-xorg-legacy
}
