function install-eclipse() {
    ide=eclipse-jee-neon
    src_file=/home/yankov/install/java/eclipse/eclipse-jee-neon-2-linux-gtk-x86_64.tar.gz
    dest_dir=/opt/$ide
    
    mkdir -p $dest_dir
    sudo tar -xvzf $src_file --directory $dest_dir
    
    sudo shortcut $ide $dest_dir/eclipse/eclipse $dest_dir/eclipse/icon.xpm
    
    sudo chown --recursive yankov $dest_dir/eclipse
    
    echo "Installation successful"
}