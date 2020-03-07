function mp4-to-mp3 {
    if [ "$#" != "1" ]; then
        echo "mp4-to-mp3 <input>"
        return
    fi

    input=$1

    avconv -i $input $input.mp3
}
