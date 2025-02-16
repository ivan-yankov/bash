function help-convert-video {
  echo "Lossless video conversion."
  echo
  echo "Usage: convert-video input-file output-file"
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

  input="$1"
  filename=$(basename -- "$input")
  extension="${filename##*.}"
  basename="${filename%.*}"

  case "$extension" in
    webm)
      # WebM to MP4
      output="${basename}.mp4"
      echo "Converting WebM to MP4 (lossless video, high-quality audio)..."
      ffmpeg -i "$input" -c:v libx264 -preset ultrafast -crf 0 -c:a aac -b:a 512k "$output"
      ;;
    mp4)
      # MP4 to WebM
      output="${basename}.webm"
      echo "Converting MP4 to WebM (high quality VP9 + Opus)..."
      ffmpeg -i "$input" -c:v libvpx-vp9 -crf 15 -b:v 0 -c:a libopus -b:a 512k "$output"
      ;;
    *)
      echo "Unsupported input file format: $extension"
      echo "Only .mp4 and .webm are supported."
      exit 1
      ;;
  esac
}
