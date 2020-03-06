function mp4-to-mp3 {
    if [ "$#" != "2" ]; then
        echo "mp4-to-mp3 <input> <output>"
        return
    fi

    input=$1
    output=$2
    
    avconv -i $input $output
}