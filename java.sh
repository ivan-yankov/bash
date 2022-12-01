function java-download {
  is-defined $1 && is-defined $2 && is-defined $3 || return 1

  local image_type=$1 # jdk, jre
  local version=$2 # 1, 2, 3, ...
  local dest=$3

  curl -X GET -L https://api.adoptium.net/v3/binary/latest/$version/ga/linux/x64/$image_type/hotspot/normal/eclipse --output $dest/$image_type-$version.tar.gz
}

function java-extract {
  is-defined $1 || return 1
  local archive=$1

  untargz $archive
  local d=$(targz-root $archive)

  mv $d $(dirname $archive)/$(basename $archive .tar.gz)
}

function java-install {
  is-defined $1 && is-defined $2 || return 1

  local image_type=$1 # jdk, jre
  local version=$2 # 1, 2, 3, ...

  local archive=/tmp/$image_type-$version.tar.gz

  java-download $image_type $version $(dirname $archive)
  java-extract $archive

  local dest=/opt/java/$image_type-$version
  sudo mkdir -p $(dirname $dest)
  sudo rm -rf $dest
  sudo mv $(dirname $archive)/$image_type-$version $dest
  rm $archive
}

function java-set {
  local image_type=$1 # jdk, jre
  local version=$2 # 1, 2, 3, ...

  sudo rm /usr/bin/java
  sudo ln -s /opt/java/$image_type-$version/bin/java /usr/bin/java
}
