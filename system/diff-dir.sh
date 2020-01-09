function diffdir {
    if [ "$#" != "2" ]; then
        echo "diffdir <src> <dest>"
        return
    fi

    src=$1
    dest=$2

    diff -qr $src $dest
}