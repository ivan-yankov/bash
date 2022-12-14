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
  export BASH_LOCAL=~/.bash
  load $BASH_LOCAL
  
  is-defined $DATA || return 1
  is-defined $TEMP || return 1
  is-defined $TEXT_EDITOR || return 1
  is-defined $JAVA || return 1
  is-defined $APP_IMAGE || return 1
  is-defined $YOUTUBE_DOWNLOADER || return 1

  load $(dirname $BASH_SOURCE)
}
