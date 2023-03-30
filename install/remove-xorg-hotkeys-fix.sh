# dsc:Remove fix hotkeys in xorg used in linux ubuntu.
function remove-xorg-hotkeys-fix {
  sudo apt install ppa-purge
  sudo rm /etc/apt/preferences.d/pin-xorg-hotkeys
  sudo ppa-purge ppa:nrbrtx/xorg-hotkeys -y
  sudo apt-get update
  sudo apt-get remove xserver-common xserver-xorg-core xserver-xorg-legacy -y
}
