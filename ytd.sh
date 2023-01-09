function downloader {
  is-defined $PROGRAMS || return 1
  echo $PROGRAMS/youtube/youtube-dl
}

function ytd-get {
  is-defined $PROGRAMS || return 1
  sudo mkdir -p $(dirname $(downloader))
  sudo curl -X GET -L https://yt-dl.org/downloads/latest/youtube-dl --output $downloader
}

function ytd-remove {
  is-defined $PROGRAMS || return 1
  sudo rm -rf $(dirname $(downloader))
}

function ytd-help {
  is-defined $PROGRAMS || return 1
  python $(downloader) --help
}

function ytd-formats {
  is-defined $PROGRAMS || return 1
  python $(downloader) -F $1
}

function ytd-download {
  is-defined $PROGRAMS &&  is-defined $1 || return 1
  local fmt=$(ytd-formats $1 | grep best | cut -d ' ' -f1)
  python $(downloader) -f $fmt $1
}
