function help-audio-outputs {
  echo "List audio outputs."
  echo
  echo "Usage: audio-outputs"
}

function audio-outputs {
  if [[  $1 == "-h"  ]]; then
    help-audio-outputs
    return 0
  fi

  pactl list short sinks
}
