function desktop-file {
  cmd-dsc "Create a desktop file for an executable."
  cmd-dsc "The entry becomes available in 'Show Applications'."
  cmd-dsc "startup-wm-class lets the icon be added to the Dock and avoids a"
  cmd-dsc "duplicate icon appearing there at launch. To find its value: start"
  cmd-dsc "the application, run 'xprop WM_CLASS', click the application window"
  cmd-dsc "rather than its icon, and read the value from the terminal."
  cmd-arg name string "Base name of the .desktop file"
  cmd-arg app-name string "Name shown in the application list"
  cmd-arg target string "Command line to execute"
  cmd-arg icon string "Path to the icon"
  cmd-arg terminal "enum(true|false)" "Whether the application runs in a terminal"
  cmd-arg startup-wm-class string "WM_CLASS reported by the application"
  cmd-example "desktop-file audacity Audacity /opt/audacity/audacity.AppImage /opt/audacity/icon.png false Audacity"
  cmd-parse "$@" || return $CMD_RC

  local file=/tmp/$ARG_name.desktop

  {
    echo "[Desktop Entry]"
    echo "Name=$ARG_app_name"
    echo "Comment=$ARG_app_name"
    echo "Exec=$ARG_target"
    echo "Icon=$ARG_icon"
    echo "Terminal=$ARG_terminal"
    echo "Type=Application"
    echo "StartupWMClass=$ARG_startup_wm_class"
  } > "$file"

  chmod +x "$file"
  sudo chown "$USER" "$file"
  sudo mv "$file" /usr/share/applications
}
