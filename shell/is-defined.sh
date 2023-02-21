# dsc:Check if argument is defined.
# dsc:Returns 0 if parameter is defined, 1 otherwise.
# arg:$1 argument to be checked
function is-defined {
  if [ -z $1 ]; then
    echo "Missing parameter or variable in [${FUNCNAME[1]}]"
    return 1
  else
    return 0
  fi
}
