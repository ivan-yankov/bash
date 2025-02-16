function help-newmvn {
  echo "Create new maven project."
  echo
  echo "Usage: newmvn name main-class"
}

function newmvn {
  if [  $# -eq 0  ]; then
    help-newmvn
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-newmvn
    return 0
  fi

  local name=$1
  local main_class=$2
  local package=com.example
  local package_path=com/example
  local run_file=$name/run
  local version='1.0-SNAPSHOT'
  local main_file=$name/src/main/java/$package_path/$main_class.java

  mvn archetype:generate -DgroupId=$package.$name -DartifactId=$name -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

  rm -rf $name/src/main/java/$package_path/$name
  rm -rf $name/src/test/java/$package_path/$name

  touch $main_file
  echo "package $package;" > $main_file
  echo "" >> $main_file
  echo "public class $main_class {" >> $main_file
  echo "  public static void main(String[] args) {" >> $main_file
  echo "    System.out.println(\"Hello world!\");" >> $main_file
  echo "  }" >> $main_file
  echo "}" >> $main_file

  touch $run_file
  echo "mvn clean compile test package" > $run_file
  echo "java -cp target/$name-$version.jar $package.$main_class" >> $run_file
}
