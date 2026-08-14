function audio-outputs {
  cmd-dsc "List the available audio outputs."
  cmd-example "audio-outputs"
  cmd-parse "$@" || return $CMD_RC

  pactl list short sinks
}
