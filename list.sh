function cmds {
  echo "Commands:"
  echo "---------"
  for dir in $BASH_SCRIPTS/*
  do
    for file in $dir*
    do
      if [ ${file: -3} == ".sh" ]; then
        items=`cat $file`
        flag=0
        for item in $items
        do
          if [ $flag == 1 ]; then
            echo $item
            flag=0
          fi
          if [ $item == "function" ]; then
            flag=1
          fi
        done
      fi
    done
  done
}

function aliases {
  aliases_file=$BASH_SCRIPTS/aliases.sh
  if [ -f "$aliases_file" ]; then
    echo
    echo "Aliases:"
    echo "--------"
    cat $aliases_file
  fi

  local_aliases_file=$BASH_SCRIPTS/aliases-local.sh
  if [ -f "$local_aliases_file" ]; then
    echo
    echo "Local aliases:"
    echo "--------------"
    cat $local_aliases_file
  fi
}
