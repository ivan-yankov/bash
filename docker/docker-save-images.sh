function docker-save-images {
  cmd-dsc "Save every docker image to a .tar file, with its repository and tag"
  cmd-dsc "recorded alongside so docker-load-images can restore them."
  cmd-arg target string "Directory to write the images into"
  cmd-example "docker-save-images ~/docker-images"
  cmd-parse "$@" || return $CMD_RC

  mkdir -p "$ARG_target"

  local images=()
  # --format avoids parsing the padded table, and skips the header row.
  mapfile -t images < <(docker images --format '{{.Repository}} {{.Tag}} {{.ID}}')

  local line repo tag id
  for line in "${images[@]}"; do
    read -r repo tag id <<<"$line"
    echo "Save image: $repo:$tag ($id)"
    docker save --output "$ARG_target/$id.tar" "$id"
    printf '%s\n' "$repo" > "$ARG_target/$id.repository"
    printf '%s\n' "$tag" > "$ARG_target/$id.tag"
  done
}
