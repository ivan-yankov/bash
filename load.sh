dir=$1

if [ -n $dir ]; then
  dir=$(dirname $BASH_SOURCE)
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
