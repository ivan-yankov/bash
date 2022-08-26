function java-download {
  image_type=$1 # jdk, jre
  version=$2 # 1, 2, 3, ...

  curl -X GET -L https://api.adoptium.net/v3/binary/latest/$version/ga/linux/x64/$image_type/hotspot/normal/eclipse --output $image_type-$version.tar.gz
}

function java-install {
  image_type=$1 # jdk, jre
  version=$2 # 1, 2, 3, ...
  archive_file=$image_type-$version.tar.gz

  untargz $archive_file
  d=$(targz-root $archive_file)

  sudo mkdir -p /opt/java
  dest=/opt/java/$image_type-$version
  sudo rm -rf $dest
  sudo mv $d $dest
}

function java-set {
  image_type=$1 # jdk, jre
  version=$2 # 1, 2, 3, ...

  sudo rm /usr/bin/java
  sudo ln -s /opt/java/$image_type-$version/bin/java /usr/bin/java
}
