function install-stickynotes {
    sudo apt-add-repository ppa:umang/indicator-stickynotes
    sudo apt-get update
    sudo apt-get install indicator-stickynotes
    
    echo "Installation successful"
}