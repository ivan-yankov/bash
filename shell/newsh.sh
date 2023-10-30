# dsc:Create new shell file function with documentation header.
# arg:$1 function name
function newsh {
  is-defined $1 || return 1
  local fn=$1

  local file=$fn.sh
  touch $file
  
  echo '# dsc:<Command description>' >> $file
  echo '# env:<Required environment variables>' >> $file
  echo '# arg:$1 <Argument>' >> $file
  echo "function $fn {" >> $file
  echo '}' >> $file
}
