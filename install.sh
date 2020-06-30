export MICRO_TEXT_EDITOR_DIR="/opt/bin"

# fixes hotkeys in xorg used in linux mint 19.*
# due to bug introduced hotkeys trigger happens
# on key-press instead of key-release
# this prevents hotkeys with more than two keys
# to work properly
function fix-xorg-hotkeys {
  sudo apt-add-repository ppa:nrbrtx/xorg-hotkeys
  sudo apt update
  sudo apt dist-upgrade
}

function install-audacity {
  sudo add-apt-repository ppa:ubuntuhandbook1/audacity
  sudo apt update
  sudo apt install audacity
}

function install-flac {
  sudo apt install flac
}

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
}

function install-openjfx {
  sudo apt install openjfx=8u161-b12-1ubuntu2 libopenjfx-java=8u161-b12-1ubuntu2 libopenjfx-jni=8u161-b12-1ubuntu2
  sudo apt-mark hold openjfx libopenjfx-java libopenjfx-jni
}

function install-micro-text-editor {
  sudo apt install xclip
  sudo mkdir -p $MICRO_TEXT_EDITOR_DIR
  sudo curl -sL https://gist.githubusercontent.com/zyedidia/d4acfcc6acf2d0d75e79004fa5feaf24/raw/a43e603e62205e1074775d756ef98c3fc77f6f8d/install_micro.sh | sudo bash -s linux64 $MICRO_TEXT_EDITOR_DIR
  sudo update-alternatives --install /usr/bin/editor editor $MICRO_TEXT_EDITOR_DIR/micro 1
  sudo select-editor
}

function uninstall-micro-text-editor {
  sudo update-alternatives --remove editor $MICRO_TEXT_EDITOR_DIR/micro
  sudo rm /opt/bin/micro
  sudo select-editor
}
