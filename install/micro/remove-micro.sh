function remove-micro {
  cmd-dsc "Remove the micro text editor and point te at nano."
  cmd-example "remove-micro"
  cmd-parse "$@" || return $CMD_RC

  sudo ln -sf /bin/nano /usr/bin/te
  sudo rm -rf /opt/micro
}
