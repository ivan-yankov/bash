# dsc:Set default audio output device.
# env:$DEFAULT_AUDIO_OUTPUT device name
function set-default-audio-output {
  is-defined $DEFAULT_AUDIO_OUTPUT || return 1
  pacmd set-default-sink $DEFAULT_AUDIO_OUTPUT
}
