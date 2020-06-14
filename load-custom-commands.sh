export BASH_SCRIPTS=~/data/repos/bash
export PATH=$PATH:$BASH_SCRIPTS

for file in $BASH_SCRIPTS/*
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

for dir in $BASH_SCRIPTS/*/
do
  for file in $dir*
  do
    if [ ${file: -3} == ".sh" ]; then
      source $file
    fi
  done
done
