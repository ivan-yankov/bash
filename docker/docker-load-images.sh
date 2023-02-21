# dsc:Load docker images from .tar files.
# arg:$1 directory with docker images
function docker-load-images {
  is-defined $1 || return 1

  local dir=$1

  for f in $dir/*.tar; do
    local id=$(file-name-without-ext $f)
    local repo=$(cat $dir/$id.repository)
    local tag=$(cat $dir/$id.tag)

    echo "Load image: $id"
    docker load --input $f

    echo "Tag image: $id -> $repo:$tag"
    docker tag $id $repo:$tag
  done
}
