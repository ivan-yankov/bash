# Behaviour of the AppImage build commands.
#
# The command is driven end to end against a fixture project: a real ini file,
# real jars, a real JRE archive and a stand-in appimagetool. Only the network
# fetch of appimagetool is avoided, by putting the tool in the cache first.

setup() {
  load_commands

  mkdir -p project/jar cache

  # Two jars, reached through a pattern, which is how the real projects are
  # laid out.
  echo "jar one" > project/jar/one.jar
  echo "jar two" > project/jar/two.jar
  echo "icon" > project/icon.png

  cat > project/release.ini <<'INI'
JvmVersion=17
JvmXms=2G
JvmXmx=6G
ApplicationJars=jar/*
MainClass=com.example.Main
Parameters=$(tput lines) $(tput cols)
ApplicationName=demo
IsTerminalApplication=true
IconFile=icon.png
Before=tput civis
After=tput cnorm
INI

  # A JRE archive whose root directory is named after the JRE build rather
  # than after the archive, exactly as the Adoptium archives are.
  mkdir -p "jdk-17.0.6+10-jre/bin"
  echo "java" > "jdk-17.0.6+10-jre/bin/java"
  tar -czf cache/jre-17.tar.gz "jdk-17.0.6+10-jre"
  rm -rf "jdk-17.0.6+10-jre"

  # Stand-in for appimagetool: it produces the file the real tool would.
  arch=$(uname -m)
  cat > "cache/appimagetool-$arch.AppImage" <<'TOOL'
#!/bin/bash
# $1 is the AppDir; the real tool writes the AppImage next to the project.
echo "appimage of $1" > "$PWD/demo-$(uname -m).AppImage"
TOOL
  chmod +x "cache/appimagetool-$arch.AppImage"
}

# appimagetool writes its output into the working directory, and the ini file
# names the icon relative to it, so the build runs from the project directory,
# which is how the command is used. Each test has its own subshell, so the
# directory change is contained.
build() {
  cd project || { fail "no project directory"; return 1; }
  run app-image-build-jvm-based release.ini ../cache "$OLDPWD/demo.AppImage"
  cd .. || return 1
}

test_build_produces_the_app_image() {
  build
  assert_rc 0 "$rc"
  assert_file demo.AppImage
}

test_build_copies_every_jar_matched_by_the_pattern() {
  build
  assert_file cache/AppDir/jar/one.jar
  assert_file cache/AppDir/jar/two.jar
}

test_build_installs_the_jre_whatever_the_archive_root_is_called() {
  build
  assert_file cache/AppDir/jre/bin/java
}

test_build_writes_a_runnable_apprun() {
  build
  assert_file cache/AppDir/AppRun
  [ -x cache/AppDir/AppRun ] || fail "AppRun is not executable"
  local content
  content=$(cat cache/AppDir/AppRun)
  assert_contains "$content" "com.example.Main"
  # The parameters are evaluated when the AppImage runs, not when it is built.
  assert_contains "$content" '$(tput lines) $(tput cols)'
  assert_contains "$content" 'tput civis'
  assert_contains "$content" 'tput cnorm'
}

test_build_writes_the_desktop_entry() {
  build
  assert_file cache/AppDir/demo.desktop
  local content
  content=$(cat cache/AppDir/demo.desktop)
  assert_contains "$content" "Name=demo"
  assert_contains "$content" "Terminal=true"
}

test_build_reports_a_pattern_that_matches_no_jars() {
  replace-text "ApplicationJars=jar/*" "ApplicationJars=lib/*" project/release.ini

  build
  assert_rc_nonzero "$rc"
  assert_contains "$output" "no jars matched"
}

test_build_reports_a_missing_jre_archive() {
  rm -f cache/jre-17.tar.gz

  build
  assert_rc_nonzero "$rc"
  assert_contains "$output" "missing"
}
