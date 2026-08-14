function configure-audacity {
  cmd-dsc "Copy the audacity configuration and macros into place."
  cmd-example "configure-audacity"
  cmd-parse "$@" || return $CMD_RC

  local cfg=~/.audacity-data
  local src
  src=$(dirname "${BASH_SOURCE[0]}")

  mkdir -p "$cfg"
  cp "$src/audacity.cfg" "$cfg"

  mkdir -p "$cfg/Macros"
  cp "$src/FLAC_Normalize.txt" "$cfg/Macros"
}
