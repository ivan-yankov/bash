function flac-test {
  is-defined $1 || return 1
  find $1 -type f -iname '*.flac' -print0 | xargs --null flac -wst
}

function ytd-get {
  is-defined $YOUTUBE_DOWNLOADER || return 1
  sudo mkdir -p $(dirname $YOUTUBE_DOWNLOADER)
  sudo curl -X GET -L https://yt-dl.org/downloads/latest/youtube-dl --output $YOUTUBE_DOWNLOADER
}

function ytd-remove {
  is-defined $YOUTUBE_DOWNLOADER || return 1
  sudo rm -rf $(dirname $YOUTUBE_DOWNLOADER)
}

function ytd-help {
  is-defined $YOUTUBE_DOWNLOADER || return 1
  python $YOUTUBE_DOWNLOADER --help
}

function ytd-formats {
  is-defined $YOUTUBE_DOWNLOADER || return 1
  python $YOUTUBE_DOWNLOADER -F $1
}

function ytd-download {
  # provide format and url
  is-defined $YOUTUBE_DOWNLOADER && is-defined $1 && is-defined $2 || return 1
  python $YOUTUBE_DOWNLOADER -f "$@"
}
