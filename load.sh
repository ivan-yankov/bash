if [ -z $1 ]; then
  dir=$(dirname $BASH_SOURCE)
else
  dir=$1
fi

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
