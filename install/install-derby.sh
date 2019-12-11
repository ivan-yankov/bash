function install-derby {
    if [ "$#" != "2" ]; then
        echo "install-derby <version> <file>"
        return
    fi

    version=$1
    src_file=$2
    dest_dir=/opt
    
    sudo tar -xvzf $src_file --directory $dest_dir
    sudo mv $dest_dir/$version $dest_dir/db-derby
    
    ide=db-derby
    
    sudo chown --recursive yankov $dest_dir/$ide
    
    echo "Installation successful"
}