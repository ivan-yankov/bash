# dsc:Create new shell file function with documentation header.
# arg:$1 function name
function newsh {
  is-defined $1 || return 1
  local fn=$1

  local file=$fn.sh
  touch $file
  
  echo '# dsc:' >> $file
  echo '# env:' >> $file
  echo '# arg:$1' >> $file
  echo "function $fn {" >> $file
  echo '}' >> $file
}
