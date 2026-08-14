function extract-audio {
  cmd-dsc "Extract the audio track of a video file to mp3."
  cmd-arg input file "Video file to extract from"
  cmd-example "extract-audio holiday.mkv"
  cmd-parse "$@" || return $CMD_RC

  local output
  output=$(file-name-without-ext "$ARG_input").mp3
  ffmpeg -i "$ARG_input" "$output"
}
