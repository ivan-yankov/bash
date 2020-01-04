# fixes hotkeys in xorg used in linux mint 19.*
# due to bug introduced hotkeys trigger happens
# on key-press instead of key-release
# this prevents hotkeys with more than two keys
# to work properly
sudo apt-add-repository ppa:nrbrtx/xorg-hotkeys
sudo apt update
sudo apt dist-upgrade
