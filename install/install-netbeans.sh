function install-netbeans() {
    jdk_path=/opt/jdk1.8.0_161
    src_dir=/home/yankov/install/java/netbeans
    netbeans=netbeans-8.0.2
    src_file=$src_dir/$netbeans.zip
    dest_dir=/opt
    user_dir=/home/yankov/.netbeans
    cache_dir=/home/yankov/.cache/netbeans
    
    sudo chown --recursive yankov $user_dir
    sudo chown --recursive yankov $cache_dir
    
    mkdir -p $user_dir
    mkdir -p $cache_dir
    
    sudo unzip $src_file -d $dest_dir
    
    sudo python $install_scripts_folder/cfg-netbeans.py $dest_dir/$netbeans $user_dir $cache_dir $jdk_path
    
    sudo chown --recursive yankov $dest_dir/$netbeans
    
    shortcut_name="NetBeans"
    execution_file=$dest_dir/$netbeans/bin/netbeans
    icon=$dest_dir/$netbeans/nb/netbeans.png
    sudo shortcut $shortcut_name $execution_file $icon
    
    echo "Installation successful"
}