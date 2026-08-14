function install-micro {
  cmd-dsc "Install the micro text editor into /opt/micro and configure it."
  cmd-example "install-micro"
  cmd-parse "$@" || return $CMD_RC

  local dir=/opt/micro
  sudo mkdir -p "$dir"
  sudo curl -sL https://gist.githubusercontent.com/zyedidia/d4acfcc6acf2d0d75e79004fa5feaf24/raw/a43e603e62205e1074775d756ef98c3fc77f6f8d/install_micro.sh \
    | sudo bash -s linux64 "$dir"

  local cfg=~/.config/micro
  local src
  src=$(dirname "${BASH_SOURCE[0]}")
  mkdir -p "$cfg"
  cp "$src"/*.json "$cfg"

  sudo apt install -y xclip
}
