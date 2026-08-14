function gnome-display-background {
  cmd-dsc "Set a plain grey desktop background in Gnome."
  cmd-example "gnome-display-background"
  cmd-parse "$@" || return $CMD_RC

  gsettings set org.gnome.desktop.background picture-uri ''
  gsettings set org.gnome.desktop.background primary-color 'rgb(150, 150, 150)'
  gsettings set org.gnome.desktop.background picture-options 'none'
}
