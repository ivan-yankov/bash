function install-xorg-hotkeys-fix {
  cmd-dsc "Install the xorg hotkeys fix used on Ubuntu."
  cmd-dsc "A bug makes hotkeys trigger on key press instead of key release,"
  cmd-dsc "which stops hotkeys of more than two keys working properly."
  cmd-dsc "See https://launchpad.net/~nrbrtx/+archive/ubuntu/xorg-hotkeys"
  cmd-example "install-xorg-hotkeys-fix"
  cmd-parse "$@" || return $CMD_RC

  sudo apt-add-repository -y ppa:nrbrtx/xorg-hotkeys
  sudo apt-get update
  sudo apt-get install -y --only-upgrade \
    xserver-common xserver-xorg-core xserver-xorg-legacy

  # Pin the version so a later upgrade does not undo the fix.
  local pin=/etc/apt/preferences.d/pin-xorg-hotkeys
  {
    echo "Package: *"
    echo "Pin: release o=LP-PPA-nrbrtx-xorg-hotkeys"
    echo "Pin-Priority: 1337"
  } | sudo tee "$pin" > /dev/null
}
