function help-java-set {
  echo "Set java to the operating system."
  echo "Expects java to be in /opt/java directory."
  echo "OSTYPE operating system type."
  echo
  echo "Usage: java-set image version"
  echo "  image: jdk, jre"
  echo "  version: 1, 2, 3, ..."
}

function java-set {
  if [  $# -eq 0  ]; then
    help-java-set
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-java-set
    return 0
  fi

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
