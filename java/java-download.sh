# dsc:Download java.
# arg:$1 image type: jdk | jre
# arg:$2 version: 1, 2, 3, ...
# arg:$3 destination directory
function java-download {
  is-defined $1 && is-defined $2 && is-defined $3 || return 1

  local image_type=$1
  local version=$2
  local dest=$3

  curl -X GET -L https://api.adoptium.net/v3/binary/latest/$version/ga/linux/x64/$image_type/hotspot/normal/eclipse --output $dest/$image_type-$version.tar.gz
}
