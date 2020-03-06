function webm-to-oga {
    if [ "$#" != "2" ]; then
        echo "webm-to-oga <input> <output>"
        return
    fi

    input=$1
    output=$2

    ffmpeg -i $input -vn -acodec copy $output
}