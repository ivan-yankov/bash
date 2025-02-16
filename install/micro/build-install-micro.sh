# dsc:Build micro text editor from sources, install to /opt/micro and configure.
function build-install-micro {
  local dir=/opt/micro

  sudo mkdir $dir

  cd ~/data/repos/go/src/micro && \
  git pull && \
  make && \
  sudo cp micro $dir/

  local cfg=~/.config/micro
  mkdir -p $cfg
  cp $(dirname $BASH_SOURCE)/*.json $cfg

  sudo apt install xclip
}
