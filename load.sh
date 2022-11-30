export REPOS=~/data/repos

for file in $REPOS/bash/*
do
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
