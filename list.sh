function cmds {
  echo "Commands:"
  echo "---------"
  result=()
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
            result+=("$item")
            flag=0
          fi
          if [ $item == "function" ]; then
            flag=1
          fi
        done
      fi
    done
  done

  IFS=$'\n'
  sorted=($(sort <<< "${result[*]}"))
  unset IFS

  for item in ${sorted[@]}
  do
    echo $item
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
}

function man-pack-list {
  echo "Manually installed packages without dependencies:"
  echo "-------------------------------------------------"
  comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)
}
