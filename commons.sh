function is-defined {
  if [ -z $1 ]; then
    echo "Missing parameter or variable in [${FUNCNAME[1]}]"
    return 1
  else
    return 0
  fi
}

function get-ini-value {
  is-defined $1 && is-defined $2 || return 1
  awk -F "=" '/'$1'/ {print $2}' $2
}
