function docker-load-images {
  cmd-dsc "Load docker images from the .tar files written by docker-save-images"
  cmd-dsc "and restore their repository and tag."
  cmd-arg source dir "Directory holding the .tar files"
  cmd-example "docker-load-images ~/docker-images"
  cmd-parse "$@" || return $CMD_RC

  local file id repo tag
  for file in "$ARG_source"/*.tar; do
    [ -f "$file" ] || continue
    id=$(file-name-without-ext "$file")
    repo=$(cat "$ARG_source/$id.repository")
    tag=$(cat "$ARG_source/$id.tag")

    echo "Load image: $id"
    docker load --input "$file"

    echo "Tag image: $id -> $repo:$tag"
    docker tag "$id" "$repo:$tag"
  done
}
