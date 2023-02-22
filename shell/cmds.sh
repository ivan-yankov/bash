# dsc:Show list of custom functions / commands.
# env:$BASH_LOCAL directory which:
# env:  represents custom bash entrypoint
# env:  contains link to the custom bash repository
# env:  contains bash files specific to the local machine
function cmds {
  local dir=$BASH_LOCAL
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
