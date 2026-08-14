function ssh-login {
  cmd-dsc "Add the ssh key to the agent for the rest of the uptime session."
  cmd-dsc "Asks for the key passphrase."
  cmd-arg key file "=$HOME/.ssh/id_rsa" "Private key to add"
  cmd-example "ssh-login"
  cmd-parse "$@" || return $CMD_RC

  ssh-add -k "$ARG_key"
}
