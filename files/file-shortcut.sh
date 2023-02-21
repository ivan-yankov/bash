# dsc:Create file shortcut to the Desktop directory.
# arg:$1 shortcut name
# arg:$2 target file name
# arg:$3 icon file
function file-shortcut {
  is-defined $1 && is-defined $2 && is-defined $3 || return 1
  
  local shortcut_name="$1"
  local target_file="$2"
  local icon_file="$3"

  local file=~/Desktop/$shortcut_name.desktop

  echo "[Desktop Entry]" >> $file
  echo "Name="$shortcut_name >> $file
  echo "Comment=" >> $file
  echo "Exec="$target_file >> $file
  echo "Icon="$icon_file >> $file
  echo "Terminal=false" >> $file
  echo "Type=Application" >> $file

  chmod +x $file
  chown $USER $file
}
