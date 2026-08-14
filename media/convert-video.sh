function convert-video {
  cmd-dsc "Convert video to mp4 format for archiving with consistent encoding."
  cmd-dsc "Video is encoded with HEVC, which produces smaller files than AVC at"
  cmd-dsc "the same quality. CPU processing is slower than an NVIDIA GPU but"
  cmd-dsc "analyses the video more deeply, so it gives better quality for the"
  cmd-dsc "same size. Audio is encoded with AAC."
  cmd-arg input file "Video file to convert"
  cmd-opt --vq "enum(lossless|high|medium|low)" =medium "Video quality; lossless is very slow and very large"
  cmd-opt --aq "enum(best|high|medium|low)" =high "Audio quality: 320k, 256k, 192k, 128k"
  cmd-opt --processor "enum(cpu|gpu)" =cpu "cpu is slower but produces a smaller file"
  cmd-flag -r --replace "Replace the original file with the converted one"
  cmd-example "convert-video holiday.mkv"
  cmd-example "convert-video holiday.mkv --vq high --aq best"
  cmd-example "convert-video holiday.mkv --processor gpu --replace"
  cmd-parse "$@" || return $CMD_RC

  local input=$ARG_input
  local filename dir bname
  filename="$(basename -- "$input")"
  dir="$(realpath -- "$(dirname -- "$input")")"
  bname="${filename%.*}"

  # The declarations have already rejected anything outside these sets, so
  # these are lookups rather than validation.
  local crf
  case "$ARG_vq" in
    lossless) crf=0 ;;
    high)     crf=20 ;;
    medium)   crf=25 ;;
    low)      crf=28 ;;
  esac

  local audio_bitrate
  case "$ARG_aq" in
    best)   audio_bitrate="320k" ;;
    high)   audio_bitrate="256k" ;;
    medium) audio_bitrate="192k" ;;
    low)    audio_bitrate="128k" ;;
  esac

  local output="$dir/${bname}_output.mp4"

  case "$ARG_processor" in
    cpu)
      ffmpeg -i "$input" \
        -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" \
        -c:v libx265 -crf "$crf" -preset faster -pix_fmt yuv420p \
        -c:a aac -b:a "$audio_bitrate" -movflags +faststart \
        "$output" || return
      ;;
    gpu)
      ffmpeg -i "$input" \
        -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" \
        -c:v hevc_nvenc -preset p2 -b:v 0 -rc constqp -cq:v "$crf" \
        -profile:v main -pix_fmt yuv420p \
        -c:a aac -b:a "$audio_bitrate" -movflags +faststart \
        "$output" || return
      ;;
  esac

  if [ "$ARG_replace" == "true" ]; then
    rm "$input"
    mv "$output" "$dir/${bname}.mp4"
  fi
}
