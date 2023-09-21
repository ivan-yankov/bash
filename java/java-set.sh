# dsc:Set default java for the system.
# dsc:Expects java to be in /opt/java directory.
# arg:$1 image type: jdk | jre
# arg:$2 version: 1, 2, 3, ...
function java-set {
  is-defined $1 && is-defined $2 || return 1

  local image_type=$1
  local version=$2
  local java_home=$(dirname $(find-file /opt/java/$image_type-$version java))

  sudo ln -sf $java_home/java /usr/bin/java
  echo "export JAVA_HOME=$java_home" > $BASH_LOCAL/java.sh
}
