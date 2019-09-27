function install-eclipse {
    if [ "$#" -ne 1 ]; then
        echo "Arguments: file"
        return
    fi
    
    src_file=$1
    ide=$(basename $src_file .tar.gz)
    dest_dir=/opt/$ide
    
    mkdir -p $dest_dir
    sudo tar -xvzf $src_file --directory $dest_dir
    
    create-shortcut $ide $dest_dir/eclipse/eclipse $dest_dir/eclipse/icon.xpm
    
    sudo chown --recursive yankov $dest_dir
    
    echo "Installation successful"
}