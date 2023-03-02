# dsc:Set audio input volume.
# dsc:The volume should be an integer value greater or equal than 0 (muted). Volume 65536 (0x10000) is 'normal' volume a.k.a. 100%
# env:$DEFAULT_AUDIO_INPUT device name
# env:$AUDIO_INPUT_VOLUME volume
function set-audio-input-volume {
  is-defined $DEFAULT_AUDIO_INPUT && is-defined $AUDIO_INPUT_VOLUME || return 1
  pacmd set-source-volume $DEFAULT_AUDIO_INPUT $AUDIO_INPUT_VOLUME
}
