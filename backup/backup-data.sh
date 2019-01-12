function backup-data() {
    data_dir=/home/yankov/data
    install_dir=/home/yankov/install
    vms_dir=/home/yankov/vbvms
    
    backup_dir=/media/yankov/Backup
    
    rsync --delete --inplace -a $data_dir $backup_dir
    rsync --delete --inplace -a $install_dir $backup_dir
    rsync --delete --inplace -a $vms_dir $backup_dir
    
    echo "Backup complete"
}