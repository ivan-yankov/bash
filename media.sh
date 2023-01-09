function media-flac-check {
  is-defined $1 || return 1
  find $1 -type f -iname '*.flac' -print0 | xargs --null flac -wst
}

function media-extract-audio {
  is-defined $1 || return 1
  local input="$1"
  local output=$(file-name-without-ext "$input").mp3
  ffmpeg -i "$input" "$output"
}

function media-dvd-copy {
  is-defined $1 || return 1  
  dest=~/temp/$1
  mkdir -p $dest
  sudo cp -r ./VIDEO_TS $dest
  sudo chmod +rwx $dest/VIDEO_TS/
}
