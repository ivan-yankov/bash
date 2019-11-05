function install-jdk {
    if [ "$#" != "2" ]; then
        echo "install-jdk <jdk-name> <jdk-file>"
        return
    fi

    jdk=$1
    jdk_file=$2
    dest_dir=/opt
    
    sudo tar -xvzf $jdk_file --directory $dest_dir
    
    sudo chown --recursive yankov $dest_dir/$jdk
    
    echo "Installation successful"
}