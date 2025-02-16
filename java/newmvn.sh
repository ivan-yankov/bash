function help-newmvn {
  echo "Create new maven project."
  echo
  echo "Usage: newmvn name"
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
  local main_class=Main
  local package=com.example
  local package_path=com/example
  local run_file=$name/run
  local version='1.0'
  local main_file=$name/src/main/java/$package_path/$main_class.java
  local pom_file=$name/pom.xml

  mkdir -p $name/src/main/java/$package_path
  mkdir -p $name/src/test/java/$package_path

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

  touch $pom_file
  echo "<project xmlns=\"http://maven.apache.org/POM/4.0.0\"" > $pom_file
  echo "         xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"" >> $pom_file
  echo "         xsi:schemaLocation=\"http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd\">" >> $pom_file
  echo "  <modelVersion>4.0.0</modelVersion>" >> $pom_file
  echo "  <groupId>$package.$name</groupId>" >> $pom_file
  echo "  <artifactId>$name</artifactId>" >> $pom_file
  echo "  <packaging>jar</packaging>" >> $pom_file
  echo "  <version>$version</version>" >> $pom_file
  echo "  <name>op</name>" >> $pom_file
  echo "  <url>http://maven.apache.org</url>" >> $pom_file
  echo "" >> $pom_file
  echo "  <dependencies>" >> $pom_file
  echo "    <!-- https://mvnrepository.com/artifact/org.junit.jupiter/junit-jupiter-api -->" >> $pom_file
  echo "    <dependency>" >> $pom_file
  echo "      <groupId>org.junit.jupiter</groupId>" >> $pom_file
  echo "      <artifactId>junit-jupiter-api</artifactId>" >> $pom_file
  echo "      <version>5.12.2</version>" >> $pom_file
  echo "      <scope>test</scope>" >> $pom_file
  echo "    </dependency>" >> $pom_file
  echo "  </dependencies>" >> $pom_file
  echo "" >> $pom_file
  echo "  <build>" >> $pom_file
  echo "    <plugins>" >> $pom_file
  echo "      <plugin>" >> $pom_file
  echo "        <groupId>org.apache.maven.plugins</groupId>" >> $pom_file
  echo "        <artifactId>maven-shade-plugin</artifactId>" >> $pom_file
  echo "        <version>3.5.0</version>" >> $pom_file
  echo "        <executions>" >> $pom_file
  echo "          <execution>" >> $pom_file
  echo "            <phase>package</phase>" >> $pom_file
  echo "            <goals>" >> $pom_file
  echo "              <goal>shade</goal>" >> $pom_file
  echo "            </goals>" >> $pom_file
  echo "            <configuration>" >> $pom_file
  echo "              <transformers>" >> $pom_file
  echo "                <transformer implementation=\"org.apache.maven.plugins.shade.resource.ManifestResourceTransformer\">" >> $pom_file
  echo "                  <mainClass>$package.$main_class</mainClass>" >> $pom_file
  echo "                </transformer>" >> $pom_file
  echo "              </transformers>" >> $pom_file
  echo "            </configuration>" >> $pom_file
  echo "          </execution>" >> $pom_file
  echo "        </executions>" >> $pom_file
  echo "      </plugin>" >> $pom_file
  echo "    </plugins>" >> $pom_file
  echo "  </build>" >> $pom_file
  echo "</project>" >> $pom_file
}
