# dsc:Set java for the system.
# dsc:Expects java to be in /opt/java directory.
# env:OSTYPE operating system type
# arg:$1 image type: jdk | jre
# arg:$2 version: 1, 2, 3, ...
function java-set {
  is-defined $1 && is-defined $2 && is-defined $OSTYPE || return 1

  local image_type=$1
  local version=$2

  local java_home=[]
  if [[ $OSTYPE == "linux-gnu"* ]]; then
    java_home=/opt/java/$image_type-$version/bin
  elif [[ $OSTYPE == "darwin"* ]]; then
    # mac os
    java_home=/opt/java/$image_type-$version/Contents/Home/bin
  else
    echo "Unknown OS type [$OSTYPE]"
    return 1
  fi

  sudo ln -sf $java_home/java /usr/bin/java
  echo "export JAVA_HOME=$java_home" > $BASH_LOCAL/java.sh
}
