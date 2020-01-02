function own {
    if [ "$#" != "1" ]; then
        echo "own <file>"
        return
    fi

    file=$1

    sudo chmod 755 $file
    sudo chown --recursive $USER $file
}
