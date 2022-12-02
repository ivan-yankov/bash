function cmds {
  result=()
  for dir in $(dirname $BASH_SOURCE)/*
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

function als {
  aliases_file=$(dirname $BASH_SOURCE)/aliases.sh
  if [ -f "$aliases_file" ]; then
    cat $aliases_file
  fi
}

function man-pack-list {
  # manually installed packages without dependencies
  comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)
}
