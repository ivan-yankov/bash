function docker-remove-containers {
  cmd-dsc "Remove all docker containers."
  cmd-example "docker-remove-containers"
  cmd-parse "$@" || return $CMD_RC

  local ids=()
  mapfile -t ids < <(docker ps -a -q)
  [ ${#ids[@]} -eq 0 ] && { echo "No containers."; return 0; }
  docker rm "${ids[@]}"
}
