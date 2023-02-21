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
  sudo echo "Package: *" >> $f
  sudo echo "Pin: release o=LP-PPA-nrbrtx-xorg-hotkeys" >> $f
  sudo echo "Pin-Priority: 1337" >> $f
}
