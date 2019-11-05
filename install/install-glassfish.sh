function install-glassfish {
    if [ "$#" -ne 1 ]; then
        echo "install-glassfish <file>"
        return
    fi

    src_file=$1
    dest_dir=/opt
    
    sudo unzip $src_file -d $dest_dir
    
    # mode file read and write
    sudo chmod 755 $dest_dir/$server/bin
    
    sudo chown --recursive yankov $dest_dir/$server
    
    echo "Installation successful"
}