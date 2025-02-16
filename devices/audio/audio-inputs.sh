function help-audio-inputs {
  echo "List audio inputs."
  echo
  echo "Usage: audio-inputs"
}

function audio-inputs {
  if [[  $1 == "-h"  ]]; then
    help-audio-inputs
    return 0
  fi

  pactl list short sources
}
