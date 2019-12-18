function install-tesseract {
    if [ "$#" != "2" ]; then
        echo "install-tesseract <bul-archive> <rus-archive>"
        return
    fi

    bul=$1
    rus=$2
    
    dest_dir=/usr/share/tesseract-ocr/tessdata
    
    sudo apt install tesseract-ocr
    
    sudo tar -xvzf $bul --directory $dest_dir
    sudo tar -xvzf $rus --directory $dest_dir
    
    echo "Installation successful"
}