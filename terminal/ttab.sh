function ttab {
  cmd-dsc "Open a new terminal tab."
  cmd-example "ttab"
  cmd-parse "$@" || return $CMD_RC

  xdotool key ctrl+shift+t
}
