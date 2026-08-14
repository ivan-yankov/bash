function zoom-login {
  cmd-dsc "Start the zoom client and log in."
  cmd-arg user string "User name"
  cmd-arg password string "Password"
  cmd-example "zoom-login me@example.com secret"
  cmd-parse "$@" || return $CMD_RC

  zoom --username="$ARG_user" --password="$ARG_password" &
}
