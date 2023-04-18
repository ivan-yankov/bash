# dsc:Configure audacity.
function configure-audacity {
  local cfg=~/.audacity-data
  local src=$(dirname $BASH_SOURCE)

  mkdir -p $cfg
  cp $src/audacity.cfg $cfg

  mkdir -p $cfg/Macros
  cp $src/FLAC_Normalize.txt $cfg/Macros
}
