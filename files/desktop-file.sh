function help-desktop-file {
  echo "Create desktop file for an executable."
  echo "The file will be available in 'Show Applications'."
  echo "startup-wm-class needs to be defined to allow icon to be added to the Dock and to avoid icon duplication in Dock at launch."
  echo "To get startup-wm-class:"
  echo "  - Start the application"
  echo "  - Run 'xprop WM_CLASS' in terminal"
  echo "  - Click on the application window (not the icon)"
  echo "  - Get the output from the terminal"
  echo
  echo "Usage: desktop-file file-name app-name target icon terminal startup-wm-class"
}

function desktop-file {
  if [  $# -eq 0  ]; then
    help-desktop-file
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-desktop-file
    return 0
  fi

  local file_name="$1"
  local app_name="$2"
  local target="$3"
  local icon="$4"
  local terminal="$5"
  local startup_wm_class="$6"

  local file=/tmp/$file_name.desktop

  sudo echo "[Desktop Entry]" > $file
  sudo echo "Name=$app_name" >> $file
  sudo echo "Comment=$app_name" >> $file
  sudo echo "Exec=$target" >> $file
  sudo echo "Icon=$icon" >> $file
  sudo echo "Terminal=$terminal" >> $file
  sudo echo "Type=Application" >> $file
  sudo echo "StartupWMClass=$startup_wm_class" >> $file

  sudo chmod +x $file
  sudo chown $USER $file

  sudo mv $file /usr/share/applications
}
