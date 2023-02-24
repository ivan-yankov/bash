# dsc:Install fix hotkeys in xorg used in linux ubuntu.
# dsc:Due to bug introduced hotkeys trigger happens on key-press instead of key-release.
# dsc:This prevents hotkeys with more than two keys to work properly.
# dsc:https://launchpad.net/~nrbrtx/+archive/ubuntu/xorg-hotkeys
function install-xorg-hotkeys-fix {
  sudo apt-add-repository ppa:nrbrtx/xorg-hotkeys
  sudo apt update
  sudo apt dist-upgrade

  # pin version to avoid upgrade
  f=/etc/apt/preferences.d/pin-xorg-hotkeys
  sudo touch $f
  echo "Package: *" | sudo tee --append $f
  echo "Pin: release o=LP-PPA-nrbrtx-xorg-hotkeys" | sudo tee --append $f
  echo "Pin-Priority: 1337" | sudo tee --append $f
}
