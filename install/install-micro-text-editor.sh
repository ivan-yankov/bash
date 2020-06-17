MICRO_TEXT_EDITOR_DIR="/opt/bin"

function install-micro-text-editor {
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
