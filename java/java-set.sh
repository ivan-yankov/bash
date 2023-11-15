# dsc:Set java for the system.
# dsc:Expects java to be in /opt/java directory.
# env:OSTYPE operating system type
# arg:$1 image type: jdk | jre
# arg:$2 version: 1, 2, 3, ...
function java-set {
  is-defined $1 && is-defined $2 && is-defined $OSTYPE || return 1

  local image_type=$1
  local version=$2

  if [[ $OSTYPE == "linux-gnu"* ]]; then
    local java_home=/opt/java/$image_type-$version
    sudo ln -sf $java_home/bin/java /usr/bin/java
    echo "export JAVA_HOME=$java_home" > $BASH_LOCAL/java.sh
  elif [[ $OSTYPE == "darwin"* ]]; then
    # mac os
    java_home=/opt/java/$image_type-$version/Contents/Home
    echo "export JAVA_HOME=$java_home" > $BASH_LOCAL/java.sh
    echo "alias java=$java_home/bin/java" >> $BASH_LOCAL/java.sh
  else
    echo "Unknown OS type [$OSTYPE]"
    return 1
  fi
}
