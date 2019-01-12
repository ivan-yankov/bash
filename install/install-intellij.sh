function install-intellij() {
    ide=idea-IC-181.4203.550
    src_file=/home/yankov/install/java/intellij/ideaIC-2018.1.tar.gz
    dest_dir=/opt
    
    sudo tar -xvzf $src_file --directory $dest_dir
    sudo mv $dest_dir/$ide $dest_dir/idea
    
    ide=idea
    
    sudo shortcut IntelliJ $dest_dir/$ide/bin/idea.sh $dest_dir/$ide/bin/idea.png
    
    sudo chown --recursive yankov $dest_dir/$ide
    
    echo "Installation successful"
}