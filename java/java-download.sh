# dsc:Download java.
# arg:$1 image type: jdk, jre
# arg:$2 version: 1, 2, 3, ...
# arg:$3 operating system: linux, windows, mac, solaris, aix, alpine-linux
# arg:$4 architecture: x64, x86, x32, ppc64, ppc64le, s390x, aarch64, arm, sparcv9, riscv64
function java-download {
  is-defined $1 && is-defined $2 && is-defined $3 && is-defined $4 || return 1

  local image_type=$1
  local version=$2
  local os=$3
  local arch=$4

  curl -X GET -L https://api.adoptium.net/v3/binary/latest/$version/ga/$os/$arch/$image_type/hotspot/normal/eclipse --output $image_type-$version.tar.gz
}
