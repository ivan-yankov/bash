function docker-remove-none-images {
  cmd-dsc "Remove all untagged docker images."
  cmd-example "docker-remove-none-images"
  cmd-parse "$@" || return $CMD_RC

  docker image prune
}
