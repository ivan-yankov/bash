function is-defined {
  if [ -z $1 ]; then
    echo "Missing parameter or variable in [${FUNCNAME[1]}]"
    return 1
  else
    return 0
  fi
}

function collect-functions {
  is-defined $1 || return 1
  local file=$1
  
  result=()
  items=`cat $file`
  flag=0
  for item in $items; do
    if [ $flag == 1 ]; then
      result+=("$item")
      flag=0
    fi
    if [ $item == "function" ]; then
      flag=1
    fi
  done

  IFS=$'\n'
  sorted=($(sort <<< "${result[*]}"))
  unset IFS

  for item in ${sorted[@]}; do
    CMDS=$CMDS$'\n'$item
  done
}

function load {
  is-defined $1 || return 1
  local dir=$1

  for file in $dir/*; do
    if [ -f $file ]; then
      if [ ${file} == $BASH_SOURCE ]; then
        # avoid infinite recursion
        continue
      fi
      if [ ${file: -3} == ".sh" ]; then
        source $file
        collect-functions $file
      fi
    fi
    if [ -d $file ]; then
      load $file
    fi
  done
}

function cmds {
  is-defined $CMDS || return 1
  echo "$CMDS"
}

function manual-installed-packages {
  # manually installed packages without dependencies
  comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)
}

function init {
  export BASH_LOCAL=~/.bash
  export CMDS=()

  load $BASH_LOCAL
  load $(dirname $BASH_SOURCE)
}
