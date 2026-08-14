function own {
  cmd-dsc "Take ownership of a file or directory recursively, as the current user."
  cmd-arg target path "File or directory to take ownership of"
  cmd-example "own ~/data"
  cmd-parse "$@" || return $CMD_RC

  sudo chown --recursive "$USER" "$ARG_target"
}
