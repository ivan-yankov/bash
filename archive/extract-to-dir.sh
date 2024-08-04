# dsc:Extract archive and rename root directory to provided name
# arg:$1 command for archive file extraction
# arg:$2 archive file name
# arg:$3 extracted directory destination name
# arg:$4 extracted directory destination path
function extract-to-dir {
  is-defined $1 && is-defined $2 || return 1

  local cmd=$1
  local f=$2
  local dest_name=$3
  local dest_path=$4

  eval "$cmd $f"
  d=$(arroot $f)
  mv $d $(dirname $f)/$dest_name
  sudo mv $(dirname $f)/$dest_name $dest_path
}
