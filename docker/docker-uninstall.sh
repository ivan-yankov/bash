function docker-uninstall {
    sudo apt remove -y --purge docker-engine
    sudo apt autoremove
    sudo apt autoclean

    sudo rm -rf /var/lib/docker

    echo
    echo "Docker uninstalled"
}
