function backup-folklore {
	if [ "$#" != "1" ]; then
        echo "Arguments: destination-folder"
        return
    fi

    backup_dir=$1

    data_dir=/home/yankov/data/Media/FolkloreMediaStorageOrganizer

    rsync --delete --inplace -a $data_dir $backup_dir
    
    echo "Backup complete"
}