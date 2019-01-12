function install-mysql() {
    sudo apt-get install mysql-server mysql-client mysql-common
    
    sudo python $install_scripts_folder/cfg-mysql.py
    
    sudo stop mysql
    sudo start mysql
    
    echo "Installation successful"
}