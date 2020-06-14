function size {
  if [ "$#" != "1" ]; then
    echo "size <file>"
    return
  fi

  file=$1

  sudo du -sh $file
}
