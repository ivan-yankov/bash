function audio-inputs {
  cmd-dsc "List the available audio inputs."
  cmd-example "audio-inputs"
  cmd-parse "$@" || return $CMD_RC

  pactl list short sources
}
