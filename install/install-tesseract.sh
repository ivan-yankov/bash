function install-tesseract.sh() {
    bul=/home/yankov/install/tesseract/tesseract-ocr-3.02.bul.tar.gz
    rus=/home/yankov/install/tesseract/tesseract-ocr-3.02.rus.tar.gz
    
    dest_dir=/usr/share/tesseract-ocr/tessdata
    
    sudo apt-get install tesseract-ocr
    
    sudo tar -xvzf $bul --directory $dest_dir
    sudo tar -xvzf $rus --directory $dest_dir
    
    echo "Installation successful"
}