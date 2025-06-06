# dsc:Install micro text editor to /opt/micro and configure.
function install-micro {
  local dir=/opt/micro

  sudo mkdir -p $dir
  sudo curl -sL https://gist.githubusercontent.com/zyedidia/d4acfcc6acf2d0d75e79004fa5feaf24/raw/a43e603e62205e1074775d756ef98c3fc77f6f8d/install_micro.sh | sudo bash -s linux64 $dir

  local cfg=~/.config/micro
  mkdir -p $cfg
  cp $(dirname $BASH_SOURCE)/*.json $cfg

  sudo apt install xclip
}
