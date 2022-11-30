function zoom-meeting {
  pkill zoom
  zoom --url=$1 &
}

function zoom-login {
  echo -n Username:
  read username

  echo -n Password:
  read -s password

  zoom --username=$username --password=$password &
}

function zoom-login-user-pass {
  zoom --username=$1 --password=$2 &
}
