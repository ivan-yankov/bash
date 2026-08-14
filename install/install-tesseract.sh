function install-tesseract {
  cmd-dsc "Install the tesseract OCR tool with English, Bulgarian and Russian dictionaries."
  cmd-example "install-tesseract"
  cmd-parse "$@" || return $CMD_RC

  sudo apt install -y tesseract-ocr tesseract-ocr-bul tesseract-ocr-rus
}
