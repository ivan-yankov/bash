# dsc:Set applications symoblic links.
# dsc:Links are used also by MidnightCommander to process file associations, specified in ./config/mc/mc.ext file.
function app-links {
  echo "Specify target applications (empty to skip)"

  read -p "editor: " editor
  is-defined $editor > /dev/null && sudo ln -sf $editor /usr/bin/te

  read -p "image-editor: " ie
  is-defined $ie > /dev/null && sudo ln -sf $ie /usr/bin/image-editor

  read -p "image-viewer: " iv
  is-defined $iv > /dev/null && sudo ln -sf $iv /usr/bin/image-viewer

  read -p "player: " player
  is-defined $player > /dev/null && sudo ln -sf $player /usr/bin/audio-player && sudo ln -sf $player /usr/bin/video-player

  read -p "office: " office
  is-defined $office > /dev/null && sudo ln -sf $office /usr/bin/office

  read -p "markdown: " md
  is-defined $md > /dev/null && sudo ln -sf $md /usr/bin/markdown
}
