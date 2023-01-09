function system-clear {
  sudo apt autoremove -y
  sudo apt autoclean -y
  sudo apt clean -y
  sudo apt purge $(dpkg -l | grep '^rc' | awk '{print $2}') -y
}
