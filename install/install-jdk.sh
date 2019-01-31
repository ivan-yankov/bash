function install-jdk {
    jdk=jdk1.8.0_161
    jdk_file=/home/yankov/install/java/jdk/jdk-8u161-linux-x64.tar.gz
    dest_dir=/opt
    
    sudo tar -xvzf $jdk_file --directory $dest_dir
    
    sudo update-alternatives --install /usr/bin/java java $dest_dir/$jdk/jre/bin/java 1
    sudo update-alternatives --config java
    
    sudo chown --recursive yankov $dest_dir/$jdk
    
    echo "Installation successful"
}