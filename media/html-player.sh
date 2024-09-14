function help-html-player {
  echo "Play webm and mp4 files in a browser with possibility to chromecast."
  echo "It uses chromium browser to chromecast. However chromium browser cannot access /tmp directory for example. It can access only /home directory."
  echo
  echo "Usage: html-player file"
}

function html-player {
  if [  $# -eq 0  ]; then
    help-html-player
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-html-player
    return 0
  fi

  local file=$(realpath "$1")
  local ext=$(file-ext "$file")
  local html="<html><body style=\"background-color:black;\"><video width=\"100%\" height=\"100%\" controls><source src=\"$file\" type=\"video/$ext\"></video></body></html>"
  local html_file=~/html-player.html

  echo $html > $html_file
  chromium $html_file &
}
