# dsc: Turn off the monitor (the monitor will turn on when activity is performed)
function monitor-off {
  sleep 3 && xset dpms force off
}
