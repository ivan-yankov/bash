function flac-test {
  is-defined $1 || return 1
  find $1 -type f -iname '*.flac' -print0 | xargs --null flac -wst
}

function ytd-get {
  sudo mkdir -p $(dirname $YOUTUBE_DOWNLOADER)
  sudo curl -X GET -L https://yt-dl.org/downloads/latest/youtube-dl --output $YOUTUBE_DOWNLOADER
}

function ytd-remove {
  sudo rm -rf $(dirname $YOUTUBE_DOWNLOADER)
}

function ytd-help {
  python $YOUTUBE_DOWNLOADER --help
}

function ytd-formats {
  python $YOUTUBE_DOWNLOADER -F $1
}

function ytd-download {
  # provide format and url
  is-defined $1 || return 1
  local fmt=$(ytd-formats $1 | grep best | cut -d ' ' -f1)
  python $YOUTUBE_DOWNLOADER -f $fmt $1
}

function extract-audio {
  is-defined $1 || return 1
  local input="$1"
  local output=$(file-name-without-ext "$input").mp3
  ffmpeg -i "$input" "$output"
}
