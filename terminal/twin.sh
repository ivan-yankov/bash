function twin {
  cmd-dsc "Open a new terminal window."
  cmd-example "twin"
  cmd-parse "$@" || return $CMD_RC

  xdotool key ctrl+alt+t
}
