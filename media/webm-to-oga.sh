function webm-to-oga {
    if [ "$#" != "1" ]; then
        echo "webm-to-oga <input>"
        return
    fi

    input=$1

    ffmpeg -i $input -vn -acodec copy $input.oga
}
