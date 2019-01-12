function docker-uninstall() {
    sudo apt remove -y docker-engine
    sudo apt autoremove
    sudo apt autoclean
    
    sudo rm -rf /var/lib/docker
    sudo rm -rf /home/yankov/docker
    
    echo
    echo "Docker uninstalled."
}