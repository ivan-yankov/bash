# dsc:Extract java archive and set using friendly name.
# arg:$1 archive file name
function java-extract {
  is-defined $1 || return 1
  local archive=$1

  untargz $archive
  local d=$(targz-root $archive)

  mv $d $(dirname $archive)/$(basename $archive .tar.gz)
}
