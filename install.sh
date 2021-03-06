export MICRO_TEXT_EDITOR_DIR="/opt/bin"

# fixes hotkeys in xorg used in linux ubuntu
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
  sudo apt install -y tesseract-ocr
  sudo apt install -y tesseract-ocr-bul
  sudo apt install -y tesseract-ocr-rus
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

function install-virtualbox {
  sudo add-apt-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
  wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
  wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
  sudo apt update
  sudo apt install -y virtualbox-6.1
}

function install-nodejs {
  curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
  sudo apt update
  sudo apt install -y nodejs
}
