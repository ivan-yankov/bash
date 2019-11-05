function syncdir {
    if [ "$#" != "2" ]; then
        echo "syncdir <src> <dest>"
        return
    fi

    src=$1
    dest=$2

    rsync --delete --inplace -a $src/ $dest
    
    echo "Sync complete"
}