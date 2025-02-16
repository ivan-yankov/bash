function help-convert-video {
  echo "Video conversion."
  echo "Supported formats: mp4, webm."
  echo "If video and audio codecs are compatible only container will be changed and content will not be re-encoded."
  echo "Otherwise re-encoding will be performed as per provided parameters."
  echo "Audio conversion is always lossless."
  echo "Compression level does not affect quality, but conversion speed."
  
  echo
  echo "Usage: convert-video input-file output-format video-quality compression-level"
  echo "  video-quality: best | high | medium | low"
  echo "  compression-level: high | medium | low"
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
  output_format="$2"
  quality="$3"
  compression="$4"

  filename=$(basename -- "$input")
  basename="${filename%.*}"

  crf=0
  case "$quality" in
    best)
      crf=0
      ;;
    high)
      crf=15
      ;;
    medium)
      crf=25
      ;;
    low)
      crf=50
      ;;
    *)
    echo "Unsupported quality: $quality"
    exit 1
    ;;
  esac

  cmp=placebo
  case "$compression" in
    high)
      cmp=placebo      
      ;;
    medium)
      cmp=medium
      ;;
    low)
      cmp=ultrafast
      ;;
    *)
    echo "Unsupported compression level: $compression"
    exit 1
    ;;
  esac

  vcodec=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of csv=p=0 "$input")
  acodec=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of csv=p=0 "$input")

  compatible=false
  if { [ "$vcodec" = "vp8" ] || [ "$vcodec" = "vp9" ] || [ "$vcodec" = "av1" ]; } && { [ "$acodec" = "vorbis" ] || [ "$acodec" = "opus" ]; }; then
      compatible=true
  fi

  case "$output_format" in
    mp4)
      output="${basename}.mp4"
      if $compatible; then
        echo "Codecs are compatible, conversion without re-encoding."
        ffmpeg -i "$input" -c copy "$output"
      else
        echo "Codecs are not compatible, conversion with re-encoding."
        ffmpeg -i "$input" -c:v libx264 -crf $crf -preset $cmp -c:a pcm_s16le "$output"
      fi
      ;;
    webm)
      output="${basename}.webm"
      if $compatible; then
        echo "Codecs are compatible, conversion without re-encoding."
        ffmpeg -i "$input" -c copy "$output"
      else
        echo "Codecs are not compatible, conversion with re-encoding."
        ffmpeg -i "$input" -c:v libvpx-vp9 -crf $crf -preset $cmp -c:a libopus -b:a 512k "$output"
      fi
      ;;
    *)
      echo "Unsupported input file format: $extension"
      exit 1
      ;;
  esac
}
