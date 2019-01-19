function install-tomcat {
    server=tomcat-8.0.20
    src_file=/home/yankov/install/java/servers/$server.zip
    dest_dir=/opt
    
    sudo unzip $src_file -d $dest_dir
    
    # Mode file read and write
    sudo chmod 755 $dest_dir/$server/bin/*.sh
    
    sudo chown --recursive yankov $dest_dir/$server
    
    echo "Installation successful"
}