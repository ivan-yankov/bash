function docker-remove-volumes {
  cmd-dsc "Remove all docker volumes."
  cmd-example "docker-remove-volumes"
  cmd-parse "$@" || return $CMD_RC

  local ids=()
  mapfile -t ids < <(docker volume ls -q)
  [ ${#ids[@]} -eq 0 ] && { echo "No volumes."; return 0; }
  docker volume rm "${ids[@]}"
}
