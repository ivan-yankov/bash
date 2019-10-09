function backup-data {
    src_dirs=(/home/yankov/data /home/yankov/Desktop /home/yankov/install /home/yankov/vbvms)
    dest_dir=/media/yankov/Backup

    for i in "${src_dirs[@]}"
    do
        echo Processing directory: $i
        sudo rsync --delete --inplace -a $i $dest_dir
    done

    echo "Backup complete"
}