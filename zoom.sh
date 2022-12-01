function zoom-meeting {
  is-defined $1 || return 1
  pkill zoom
  zoom --url=$1 &
}

function zoom-login {
  is-defined $1 && is-defined $2 || return 1
  zoom --username=$1 --password=$2 &
}
