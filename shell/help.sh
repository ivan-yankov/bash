# dsc:Parse and display help comment header for a function, assuming each function is in a separate file and the file name (without extension) is the same as the function name.
# dsc:Header records start with '# <key>:'.
# dsc:Supported keys for header records are:
# dsc:  dsc function description
# dsc:  env global environment variable, used in the function
# dsc:  arg function argument
# arg:$1 the file to be parsed
function help {
  is-defined $1 || return 1
  local name=$1

  local file=$(find-file $BASH_LOCAL $name.sh)

  if [ -z "$file" ]; then
    echo "Function file [$name.sh] not found"
    return 1
  fi

  IFS=$'\n' src=($(cat $file))

  if [[ ! $src[0] == '#'* ]]; then
    local msg="Documentation not available"
    echo -e "$COLOR_RED$msg$COLOR_RESET"
    return 1
  fi

  echo -e "$COLOR_MAGENTA$name$COLOR_RESET"

  for s in "${src[@]}"; do
    if [[ $s == '# dsc'* ]]; then
      echo -e "$COLOR_LIGHT_YELLOW${s#*:}$COLOR_RESET"
    fi
    if [[ $s == '# env'* ]]; then
      echo -e "$COLOR_CYAN${s#*:}$COLOR_RESET"
    fi
    if [[ $s == '# arg'* ]]; then
      echo -e "$COLOR_YELLOW${s#*:}$COLOR_RESET"
    fi
  done
}
