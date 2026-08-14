function monitor-off {
  cmd-dsc "Turn off the monitor."
  cmd-dsc "It turns back on as soon as there is any input activity."
  cmd-example "monitor-off"
  cmd-parse "$@" || return $CMD_RC

  sleep 3 && xset dpms force off
}
