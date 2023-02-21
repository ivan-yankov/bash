# dsc:Save docker images to .tar files.
# arg:$1 destination directory
function docker-save-images {
  is-defined $1 || return 1

  local dir=$1

  IFS=$'\n' imgs=($(docker images))

  mkdir -p $dir

  for img in "${imgs[@]:1}"; do
    local repo=$(echo $img | awk '{ print $1 }')
    local tag=$(echo $img | awk '{ print $2 }')
    local id=$(echo $img | awk '{ print $3 }')
    echo "Save image: $img"
    docker save --output $dir/$id.tar $id
    echo $repo > $dir/$id.repository
    echo $tag > $dir/$id.tag
  done
}
