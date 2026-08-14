function grant-access {
  cmd-dsc "Set read and write permissions recursively on a file or directory."
  cmd-dsc "Permissions are set for the user, the group and others."
  cmd-arg target path "File or directory to change"
  cmd-example "grant-access ~/shared"
  cmd-parse "$@" || return $CMD_RC

  sudo chmod -R ugo+rw "$ARG_target"
}
