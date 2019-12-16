export BASH_SCRIPTS=~/data/repos/bash
export PATH=$PATH:$BASH_SCRIPTS

file=$BASH_SCRIPTS/custom-export-path.sh
if [ -f $file ]; then
   source $file
fi
