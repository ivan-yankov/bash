function help-convert-video {
  echo "Convert video to mp4 format for archiving with consistent encoding."
  echo "Video encoder"
  echo "  HEVC - smaller files for same quality compared to AVC"
  echo "  CPU processing - slower than NVIDIA GPU, but gives better quality because of deeper video analysis"
  echo "  Output quality - as per given parameter"
  echo "Audio encoder:"
  echo "  AAC, default 128k"
  
  echo
  echo "Usage: convert-video input-file video-quality audio-quality processor [replace]"
  echo "  video-quality: lossless (very slow processing, huge file) | high | medium | low"
  echo "  audio-quality: best (320k) | high (256k) | medium (192k) | low (128k)"
  echo "  processor: cpu (slower conversion, smaller file) | gpu (faster conversion, bigger file)"
  echo "  replace: replace original file"
}

function convert-video {
  if [  $# -eq 0  ]; then
    help-convert-video
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-convert-video
    return 0
  fi

  local input="$1"
  local vq="$2"
  local aq="$3"
  local processor="$4"

  filename=$(basename -- "$input")
  bname="${filename%.*}"

  crf=0
  case "$vq" in
    lossless)
      crf=0
      ;;
    high)
      crf=20
      ;;
    medium)
      crf=25
      ;;
    low)
      crf=28
      ;;
    *)
    echo "Unsupported video quality: $vq"
    return
    ;;
  esac

  audio_bitrate="320k"
  case "$aq" in
    best)
      audio_bitrate="320k"
      ;;
    high)
      audio_bitrate="256k"
      ;;
    medium)
      audio_bitrate="192k"
      ;;
    low)
      audio_bitrate="128k"
      ;;
    *)
    echo "Unsupported audio quality: $aq"
    return
    ;;
  esac

  local output="${bname}_output.mp4"

  case "$processor" in
    cpu)
      ffmpeg -i "$input" -c:v libx265 -crf $crf -preset faster -c:a aac -b:a $audio_bitrate "$output"
      ;;
    gpu)
      ffmpeg -i "$input" -c:v hevc_nvenc -preset p2 -b:v 0 -rc constqp -cq:v $crf -profile:v main10 -c:a aac -b:a $audio_bitrate "$output"
      ;;
    *)
      echo "Unsupported processor: $processor"
      return
      ;;
  esac

  if [[ "$5" == "replace" ]]; then
      rm "$input"
      mv "$output" "$bname.mp4"
  fi
}
