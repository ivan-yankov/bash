# dsc:Install youtube downloader to /opt/youtube directory
function install-yt-download {
  curl -Lo /tmp/yt-dlp_linux https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux
  sudo mkdir -p /opt/youtube
  sudo mv /tmp/yt-dlp_linux /opt/youtube
  sudo chmod +x /opt/youtube/yt-dlp_linux
}
