function install-derby {
    version=db-derby-10.14.1.0-bin
    src_file=/home/yankov/install/java/db-derby/db-derby-10.14.1.0-bin.tar.gz
    dest_dir=/opt
    
    sudo tar -xvzf $src_file --directory $dest_dir
    sudo mv $dest_dir/$version $dest_dir/db-derby
    
    ide=db-derby
    
    sudo chown --recursive yankov $dest_dir/$ide
    
    echo "Installation successful"
}