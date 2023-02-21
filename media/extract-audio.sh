# dsc:Extract audio from video file.
# arg:$1 video file
function extract-audio {
  is-defined $1 || return 1
  local input="$1"
  local output=$(file-name-without-ext "$input").mp3
  ffmpeg -i "$input" "$output"
}
