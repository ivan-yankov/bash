function help-java-download {
  echo "Java download."
  echo
  echo "Usage: java-download image version os arch"
  echo "  image: jdk, jre"
  echo "  version: 1, 2, 3, ..."
  echo "  os: linux, windows, mac, solaris, aix, alpine-linux"
  echo "  arch: x64, x86, x32, ppc64, ppc64le, s390x, aarch64, arm, sparcv9, riscv64"
}

function java-download {
  if [  $# -eq 0  ]; then
    help-java-download
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-java-download
    return 0
  fi

  local image_type=$1
  local version=$2
  local os=$3
  local arch=$4

  curl -X GET -L https://api.adoptium.net/v3/binary/latest/$version/ga/$os/$arch/$image_type/hotspot/normal/eclipse --output $image_type-$version.tar.gz
}
