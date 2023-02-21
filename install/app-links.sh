# dsc:Set applications symoblic links.
# dsc:Links are used by MidnightCommander to process file associations, specified in ./config/mc/mc.ext file.
# dsc:editor       micro
# dsc:view         micro
# dsc:image-editor krita
# dsc:image-viewer gwenview
# dsc:audio-player vlc
# dsc:video-player vlc
# dsc:office       libreoffice
# dsc:pdf-viewer   okular
# dsc:markdown     remarkable
# env:$PROGRAMS path to the programs directory
function app-links {
  is-defined $PROGRAMS || return 1

  sudo ln -sf $PROGRAMS/micro/micro /usr/bin/editor
  sudo ln -sf $PROGRAMS/micro/micro /usr/bin/view
  sudo ln -sf /usr/bin/krita /usr/bin/image-editor
  sudo ln -sf /usr/bin/gwenview /usr/bin/image-viewer
  sudo ln -sf /usr/bin/vlc /usr/bin/audio-player
  sudo ln -sf /usr/bin/vlc /usr/bin/video-player
  sudo ln -sf /usr/bin/libreoffice /usr/bin/office
  sudo ln -sf /usr/bin/okular /usr/bin/pdf-viewer
  sudo ln -sf /usr/bin/remarkable /usr/bin/markdown
}
