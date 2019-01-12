function docker-install() {
    # Install Docker
    sudo apt install docker-engine
    
    # Change container location
    original_location=/var/lib/docker
    new_location=/home/yankov/docker
    user=yankov
    
    # Stop docker
    sudo service docker stop
    
    # Verify no docker process is running
    sudo ps faux
    
    # Move the /var/lib/docker directory to the new location
    sudo mv $original_location $new_location
    
    # Make a symlink
    sudo ln -s $new_location $original_location
    
    # Take a peek at the directory structure to make sure it looks like it did before the moving (note the trailing slash to resolve the symlink)
    sudo ls $original_location/
    
    # Start docker back up
    sudo service docker start
    
    # Add user to the docker group (this is to avoid running all docker commands with sudo)
    sudo usermod -a -G docker $user
    
    sudo chown -R yankov $original_location/*
    sudo chown -R yankov $new_location/*
    
    echo
    echo "Docker installation completed."
    echo "Reboot the system."
}