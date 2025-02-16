function help-gnome-display-background {
  echo "Set gray background on Gnome display."
  echo
  echo "Usage: gnome-display-background"
}

function gnome-display-background {
  if [[  $1 == "-h"  ]]; then
    help-gnome-display-background
    return 0
  fi

  gsettings set org.gnome.desktop.background picture-uri ''
  gsettings set org.gnome.desktop.background primary-color 'rgb(150, 150, 150)'
  gsettings set org.gnome.desktop.background picture-options 'none'
}
