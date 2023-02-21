# dsc:Start zoom messenger with login
# arg:$1 user name
# arg:$2 password
function zoom-login {
  is-defined $1 && is-defined $2 || return 1
  zoom --username=$1 --password=$2 &
}
