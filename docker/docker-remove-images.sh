function docker-remove-images {
  cmd-dsc "Remove all docker images."
  cmd-example "docker-remove-images"
  cmd-parse "$@" || return $CMD_RC

  local ids=()
  mapfile -t ids < <(docker images -q)
  [ ${#ids[@]} -eq 0 ] && { echo "No images."; return 0; }
  docker rmi -f "${ids[@]}"
}
