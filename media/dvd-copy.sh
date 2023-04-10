# dsc:Copy DVD disc files to specified directory.
# dsc:Expects cdrom drive to be mount at /mnt/cdrom.
# arg:$1 destination directory
function dvd-copy {
  is-defined $1 || return 1
  local src=/mnt/cdrom
  local dest=$1
  mkdir -p $dest
  sudo cp -r $src/VIDEO_TS $dest
  sudo chmod +rwx $dest/VIDEO_TS/
}
