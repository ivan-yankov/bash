# dsc:Set default java for the system.
# arg:$1 image type: jdk | jre
# arg:$2 version: 1, 2, 3, ...
function java-set {
  is-defined is-defined $1 && is-defined $2 || return 1

  local image_type=$1
  local version=$2

  sudo ln -sf /opt/java/$image_type-$version/bin/java /usr/bin/java
  sudo ln -sf /opt/java/$image_type-$version/bin/keytool /usr/bin/keytool
}
