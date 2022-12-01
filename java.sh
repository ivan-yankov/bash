function java-download {
  is-defined $1 && is-defined $2 && is-defined $3 || return 1

  image_type=$1 # jdk, jre
  version=$2 # 1, 2, 3, ...
  dest=$3

  curl -X GET -L https://api.adoptium.net/v3/binary/latest/$version/ga/linux/x64/$image_type/hotspot/normal/eclipse --output $dest/$image_type-$version.tar.gz
}

function java-extract {
  is-defined $1 || return 1
  archive=$1

  untargz $archive
  d=$(targz-root $archive)

  mv $d $(dirname $archive)/$(basename $archive .tar.gz)
}

function java-install {
  is-defined $1 && is-defined $2 && is-defined $3 || return 1

  image_type=$1 # jdk, jre
  version=$2 # 1, 2, 3, ...

  java-download $image_type $version /tmp
  java-extract /tmp/$image_type-$version.tar.gz

  dest=/opt/java/$image_type-$version
  sudo mkdir -p $(dirname $dest)
  sudo rm -rf $dest
  sudo mv $d $dest
  rm $archive
}

function java-set {
  image_type=$1 # jdk, jre
  version=$2 # 1, 2, 3, ...

  sudo rm /usr/bin/java
  sudo ln -s /opt/java/$image_type-$version/bin/java /usr/bin/java
}
