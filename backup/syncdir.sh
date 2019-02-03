function syncdir {
    if [ "$#" != "2" ]; then
        echo "Arguments: src dest"
        return
    fi

    src=$1
    dest=$2

    rsync --delete --inplace -a $src $dest
    
    echo "Sync complete"
}