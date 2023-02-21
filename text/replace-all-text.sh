# dsc:Replace text in all files in the current directory.
# dsc:Text match is case sensitive.
# arg:$1 text to search for
# arg:$2 text to replace with
function replace-all-text {
  is-defined $1 && is-defined $2 || return 1
  grep -rlI "$1" | xargs sed -i "s/$1/$2/g"
}
