function file-shortcut {
  is-defined $1 && is-defined $2 && is-defined $3 || return 1
  
  shortcut_name="$1"
  target_file="$2"
  icon_file="$3"

  file=~/Desktop/$shortcut_name.desktop

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

function files-count {
  ls | wc -l
}

function file-name {
  is-defined $1 || return 1
  basename -- "$1"
}

function file-name-without-ext {
  is-defined $1 || return 1
  local fn=$(file-name "$1")
  echo "${fn%.*}"
}

function file-ext {
  is-defined $1 || return 1
  local fn=$(file-name "$1")
  echo "${fn##*.}"
}

function mdv {
  is-defined $1 || return 1
  pandoc $1 | lynx -stdin
}
