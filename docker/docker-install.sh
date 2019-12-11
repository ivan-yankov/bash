function docker-install {
	location=/var/lib/docker
	
    # install docker
    sudo apt install docker-engine
    
    # add user to the docker group (this is to avoid running all docker commands with sudo)
    sudo usermod -a -G docker $USER
    
    sudo chown --recursive $user $location/
    
    echo
    echo "Docker installation completed"
    echo "Reboot the system"
}