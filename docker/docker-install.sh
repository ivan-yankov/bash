function docker-install {
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

    sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'

    sudo apt update

    sudo apt install linux-image-generic linux-image-extra-virtual

    sudo apt install docker-engine

    sudo usermod -a -G docker $USER

    echo
    echo "Docker installation completed"
    echo "Reboot the system"
}

