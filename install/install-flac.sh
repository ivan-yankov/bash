function install-flac {
  cmd-dsc "Install the flac audio codec."
  cmd-example "install-flac"
  cmd-parse "$@" || return $CMD_RC

  sudo apt install -y flac
}
