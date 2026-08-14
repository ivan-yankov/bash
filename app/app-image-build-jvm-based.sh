function app-image-build-jvm-based {
  cmd-dsc "Build a JVM based AppImage from an ini file."
  cmd-dsc "See https://www.booleanworld.com/creating-linux-apps-run-anywhere-appimage"
  cmd-dsc "The JRE archive must already be in the cache directory, named"
  cmd-dsc "jre-<version>.tar.gz. Use SDKMAN to obtain it."
  cmd-arg ini file "ini file describing the build"
  cmd-arg cache dir "Cache directory for the JRE and appimagetool"
  cmd-arg target string "Path of the AppImage to produce"
  cmd-example "app-image-build-jvm-based app.ini ~/.app-image-builder/cache ~/apps/app.AppImage"
  cmd-parse "$@" || return $CMD_RC

  local ini_file=$ARG_ini
  local cache_dir=$ARG_cache
  local app_image=$ARG_target

  local project_dir app_dir
  project_dir=$(dirname "$ini_file")
  app_dir=$cache_dir/AppDir

  mkdir -p "$cache_dir"

  local jvm_version jvm_xms jvm_xmx application_jars main_class parameters
  local application_name is_terminal_application icon_file before after
  jvm_version=$(get-ini-value JvmVersion "$ini_file")
  jvm_xms=$(get-ini-value JvmXms "$ini_file")
  jvm_xmx=$(get-ini-value JvmXmx "$ini_file")
  application_jars=$(get-ini-value ApplicationJars "$ini_file")
  main_class=$(get-ini-value MainClass "$ini_file")
  parameters=$(get-ini-value Parameters "$ini_file")
  application_name=$(get-ini-value ApplicationName "$ini_file")
  is_terminal_application=$(get-ini-value IsTerminalApplication "$ini_file")
  icon_file=$(get-ini-value IconFile "$ini_file")
  before=$(get-ini-value Before "$ini_file")
  after=$(get-ini-value After "$ini_file")

  rm -rf "$app_dir"
  mkdir -p "$app_dir/jar"

  local app_run=$app_dir/AppRun
  {
    echo '#!/bin/sh'
    echo 'cd "$(dirname "$0")"'
    echo "$before"
    echo "./jre/bin/java -Xms$jvm_xms -Xmx$jvm_xmx -Dfile.encoding=UTF-8 -classpath \"jar/*\" $main_class $parameters \"\$@\""
    echo "$after"
  } > "$app_run"
  chmod +x "$app_run"

  local desktop=$app_dir/$application_name.desktop
  {
    echo "[Desktop Entry]"
    echo "Type=Application"
    echo "Name=$application_name"
    echo "Icon=icon"
    echo "Categories=Utility"
    echo "Terminal=$is_terminal_application"
    echo "X-AppImage-Version=0.1.09"
  } > "$desktop"

  cp "$icon_file" "$app_dir/icon.png"
  cp "$project_dir/$application_jars" "$app_dir/jar"

  # The java-* commands were removed when java management moved to SDKMAN, so
  # the JRE archive has to be placed in the cache directory beforehand.
  local jre_archive=$cache_dir/jre-$jvm_version.tar.gz
  if [ ! -f "$jre_archive" ]; then
    echo "app-image-build-jvm-based: missing [$jre_archive]." >&2
    echo "Obtain the JRE with SDKMAN and place the archive there." >&2
    return 1
  fi

  tar -xzf "$jre_archive" -C "$cache_dir" || return
  mv "$cache_dir/jre-$jvm_version" "$app_dir/jre"

  local arch
  arch=$(uname -m)

  local tool=$cache_dir/appimagetool-$arch.AppImage
  if [ ! -f "$tool" ]; then
    curl -L -o "$tool" \
      "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-$arch.AppImage" || return
    chmod a+x "$tool"
  fi

  "$tool" "$app_dir" || return

  sudo mv "$project_dir/$application_name-$arch.AppImage" "$app_image"
}
