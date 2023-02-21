# dsc:Download youtube downloader tool.
# env:$PROGRAMS path to the programs directory
function ytd-get {
  is-defined $PROGRAMS || return 1
  sudo mkdir -p $(dirname $(ytd-downloader))
  sudo curl -X GET -L https://yt-dl.org/downloads/latest/youtube-dl --output $(ytd-downloader)
}
