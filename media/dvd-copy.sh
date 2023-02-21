# dsc:Copy DVD disc files to specified directory.
# arg:$1 optical disc drive path
# arg:$2 destination directory
function dvd-copy {
  is-defined $1 || return 1  
  local src=$1
  local dest=$2
  mkdir -p $dest
  sudo cp -r $src/VIDEO_TS $dest
  sudo chmod +rwx $dest/VIDEO_TS/
}
