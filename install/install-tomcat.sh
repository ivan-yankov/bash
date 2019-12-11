function install-tomcat {
    if [ "$#" != "2" ]; then
        echo "install-tomcat <server-name> <file>"
        return
    fi

    server=$1
    src_file=$2
    dest_dir=/opt
    
    sudo unzip $src_file -d $dest_dir
    
    # Mode file read and write
    sudo chmod 755 $dest_dir/$server/bin/*.sh
    
    sudo chown --recursive yankov $dest_dir/$server
    
    echo "Installation successful"
}