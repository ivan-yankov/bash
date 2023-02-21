# dsc:Install tesseract optical character recognition tool with dictionaries for english, bulgarian and russian languages.
function install-tesseract {
  sudo apt install -y tesseract-ocr
  sudo apt install -y tesseract-ocr-bul
  sudo apt install -y tesseract-ocr-rus
}
