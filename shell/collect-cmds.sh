# dsc:Collect bash functions from a given directory recursively.
# arg:$1 directory
function collect-cmds {
  is-defined $1 || return 1
  local dir=$1

  for file in $dir/*; do
    if [ -f $file ]; then
      if [ ${file: -3} == ".sh" ]; then
        if grep -q 'function' $file; then
          local fnc=$(file-name-without-ext $file)
          echo $fnc
        fi
      fi
    fi
    if [ -d $file ]; then
      collect-cmds $file
    fi
  done
}
