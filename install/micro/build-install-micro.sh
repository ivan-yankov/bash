function build-install-micro {
  cmd-dsc "Build the micro text editor from source, install it into /opt/micro"
  cmd-dsc "and copy its configuration."
  cmd-arg source dir "=$HOME/data/repos/go/src/micro" "Directory holding the micro sources"
  cmd-example "build-install-micro"
  cmd-parse "$@" || return $CMD_RC

  local dir=/opt/micro
  sudo mkdir -p "$dir"

  # A subshell keeps the caller's working directory intact.
  (
    cd "$ARG_source" || exit 1
    git pull && make && sudo cp micro "$dir/"
  ) || return

  local cfg=~/.config/micro
  local src
  src=$(dirname "${BASH_SOURCE[0]}")
  mkdir -p "$cfg"
  cp "$src"/*.json "$cfg"

  sudo apt install -y xclip
}
