# dsc:Set default audio input device.
# env:$DEFAULT_AUDIO_INPUT device name
function set-default-audio-input {
  is-defined $DEFAULT_AUDIO_INPUT || return 1
  pacmd set-default-source $DEFAULT_AUDIO_INPUT
}
