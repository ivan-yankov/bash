function system-clear {
  cmd-dsc "Remove packages and cached files no longer needed by the system."
  cmd-example "system-clear"
  cmd-parse "$@" || return $CMD_RC

  sudo apt autoremove -y
  sudo apt autoclean -y
  sudo apt clean -y

  local residual=()
  mapfile -t residual < <(dpkg -l | awk '/^rc/ { print $2 }')
  if [ ${#residual[@]} -gt 0 ]; then
    sudo apt purge -y "${residual[@]}"
  fi
}
