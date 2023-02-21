# dsc:Load bash sources recursively from provided directory.
# arg:$1 directory bash sources to be loaded from
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

        local fn=$(basename -- $file)
        local fnc="${fn%.*}"

        CMDS=$CMDS$'\n'$fnc
      fi
    fi
    if [ -d $file ]; then
      load $file
    fi
  done
}
