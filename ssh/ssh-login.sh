# dsc:Set ssh passphrase permanently for the system uptime session.
# dsc:Asks for ssh passphrase
function ssh-login {
  ssh-add -k ~/.ssh/id_rsa
}
