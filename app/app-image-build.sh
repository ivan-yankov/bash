function app-image-build {
  cmd-dsc "Build an AppImage for every ini file in a project directory."
  cmd-dsc "Expects a 'build' script in the project directory, used to build the"
  cmd-dsc "code base, and one or more ini files describing the build."
  cmd-arg project dir "Project directory"
  cmd-arg target string "Directory to write the AppImages into"
  cmd-example "app-image-build ~/data/repos/myapp ~/apps"
  cmd-parse "$@" || return $CMD_RC

  local cache_dir=~/.app-image-builder/cache

  sudo mkdir -p "$ARG_target"

  "$ARG_project/build" || return

  local ini_file application_name app_image
  for ini_file in "$ARG_project"/*.ini; do
    [ -f "$ini_file" ] || continue
    application_name=$(get-ini-value ApplicationName "$ini_file")
    app_image=$ARG_target/$application_name.AppImage

    app-image-build-jvm-based "$ini_file" "$cache_dir" "$app_image"
  done
}
