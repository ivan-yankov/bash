function is-defined {
  if [ -z $1 ]; then
    echo "Missing parameter or variable in [${FUNCNAME[1]}]"
    return 1
  else
    return 0
  fi
}

function load {
  is-defined $1 || return 1

  dir=$1

  for file in $dir/*; do
    if [ -f $file ]; then
      if [ ${file} == $BASH_SOURCE ]; then
        # avoid infinite recursion
        continue
      fi
      if [ ${file: -3} == ".sh" ]; then
        source $file
      fi
    fi
  done
}

function init {
  is-defined $1 && is-defined $2 && is-defined $3 && is-defined $4 && is-defined $5 || return 1
  
  export DATA=$1
  export TEMP=$2
  export REPOS=$3
  export TEXT_EDITOR=$4
  export YOUTUBE_DOWNLOADER=$5
  
  load $REPOS/bash
}
