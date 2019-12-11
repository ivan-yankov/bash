function diff-data {
    src_dirs=(~/data ~/install)
    dest_dir=/media/yankov/Backup

    for i in "${src_dirs[@]}"
    do
        echo Processing directory: $i
        diff -qr $i $dest_dir
    done
}