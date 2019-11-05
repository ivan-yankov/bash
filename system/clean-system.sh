function clean-system {
    sudo apt autoremove
    sudo apt autoclean
    sudo apt clean
    sudo apt purge $(dpkg -l | grep '^rc' | awk '{print $2}')
}