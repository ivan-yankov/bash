# dsc:Set audio output volume.
# dsc:The volume should be an integer value greater or equal than 0 (muted). Volume 65536 (0x10000) is 'normal' volume a.k.a. 100%
# env:$DEFAULT_AUDIO_OUTPUT device name
# env:$AUDIO_OUTPUT_VOLUME volume
function set-audio-output-volume {
  is-defined $DEFAULT_AUDIO_OUTPUT && is-defined $AUDIO_OUTPUT_VOLUME || return 1
  pacmd set-sink-volume $DEFAULT_AUDIO_OUTPUT $AUDIO_OUTPUT_VOLUME
}
