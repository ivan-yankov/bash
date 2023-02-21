# dsc:Install micro text editor.
# env:$PROGRAMS path to the programs directory
function install-micro {
  is-defined $PROGRAMS || return 1
  local dir=$PROGRAMS/micro

  sudo apt install xclip
  sudo mkdir -p $dir
  sudo curl -sL https://gist.githubusercontent.com/zyedidia/d4acfcc6acf2d0d75e79004fa5feaf24/raw/a43e603e62205e1074775d756ef98c3fc77f6f8d/install_micro.sh | sudo bash -s linux64 $dir
}
