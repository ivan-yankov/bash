# dsc:Download and install java.
# arg:$1 image type: jdk | jre
# arg:$2 version: 1, 2, 3, ...
function java-install {
  is-defined is-defined $1 && is-defined $2 || return 1

  local image_type=$1
  local version=$2

  local archive=/tmp/$image_type-$version.tar.gz

  java-download $image_type $version $(dirname $archive)
  java-extract $archive

  local dest=/opt/java/$image_type-$version
  sudo mkdir -p $(dirname $dest)
  sudo rm -rf $dest
  sudo mv $(dirname $archive)/$image_type-$version $dest
  rm $archive
}
