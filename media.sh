YOUTUBE_DOWNLOADER_DIR="/opt/youtube-downloader"
YOUTUBE_DOWNLOADER_FILE="youtube-dl"

function flac-test {
  dir=$1
  find $dir -type f -iname '*.flac' -print0 | xargs --null flac -wst
}

function ytd-get {
  sudo mkdir -p $YOUTUBE_DOWNLOADER_DIR
  sudo curl -X GET -L https://yt-dl.org/downloads/latest/youtube-dl --output $YOUTUBE_DOWNLOADER_DIR/$YOUTUBE_DOWNLOADER_FILE
}

function ytd-remove {
  sudo rm $YOUTUBE_DOWNLOADER_DIR/$YOUTUBE_DOWNLOADER_FILE
}

function ytd-help {
  python $YOUTUBE_DOWNLOADER_DIR/$YOUTUBE_DOWNLOADER_FILE --help
}

function ytd-formats {
  python $YOUTUBE_DOWNLOADER_DIR/$YOUTUBE_DOWNLOADER_FILE -F $1
}

function ytd-download {
  # provide format and url
  python $YOUTUBE_DOWNLOADER_DIR/$YOUTUBE_DOWNLOADER_FILE -f "$@"
}
