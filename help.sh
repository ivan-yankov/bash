# dsc:Parse and display help comment header for a function, assuming each function is in a separate file and the file name (without extension) is the same as the function name.
# dsc:Header records start with '# <key>:'.
# dsc:Supported keys for header records are:
# dsc:  dsc function description
# dsc:  env global environment variable, used in the function
# dsc:  arg function argument
# env:$BASH_LOCAL directory with shells specific to the local system, by default ~/.bash
# arg:$1 the file to be parsed
function help {
  is-defined $1 || return 1
  local name=$1

  local file=$(find-file $(dirname $BASH_SOURCE) $name.sh)
  is-defined $file > /dev/null || file=$(find -L $BASH_LOCAL -type f -name $name.sh)
  is-defined $file > /dev/null || { echo "Function file [$name.sh] not found"; return 1; }

  IFS=$'\n' src=($(cat $file))

  if [[ ! $src[0] == '#'* ]]; then
    local msg="Documentation not available"
    printf "${COLOR_RED}${msg}${COLOR_RESET}\n"
    return 1
  fi

  printf "${COLOR_MAGENTA}${name}${COLOR_RESET}\n"

  for s in "${src[@]}"; do
    if [[ $s == '# dsc'* ]]; then
      printf "${COLOR_LIGHT_YELLOW}${s#*:}${COLOR_RESET}\n"
    fi
    if [[ $s == '# env'* ]]; then
      printf "${COLOR_CYAN}${s#*:}${COLOR_RESET}\n"
    fi
    if [[ $s == '# arg'* ]]; then
      printf "${COLOR_YELLOW}${s#*:}${COLOR_RESET}\n"
    fi
  done
}
