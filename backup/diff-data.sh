function diff-data() {
    data_dir=/home/yankov/data
    install_dir=/home/yankov/install
    vms_dir=/home/yankov/vbvms
    
    backup_dir=/media/yankov/Backup
    
    diff -qr $data_dir $backup_dir
    diff -qr $install_dir $backup_dir
    diff -qr $vms_dir $backup_dir
}