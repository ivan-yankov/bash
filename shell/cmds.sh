# dsc:Show list of custom functions / commands.
function cmds {
  local dir=$(dirname $(dirname $BASH_SOURCE))
  is-defined $1 > /dev/null && dir=$1

  for file in $dir/*; do
    if [ -f $file ]; then
      if [ ${file: -3} == ".sh" ]; then
        local fnc=$(file-name-without-ext $file)
        echo $fnc
      fi
    fi
    if [ -d $file ]; then
      cmds $file
    fi
  done
}
