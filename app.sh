function release-app-image {
  local builder_dir=$REPOS/app-image-builder
  local project_dir=$PWD
  local cache_dir=~/.app-image-builder/cache
  local ini_file=$project_dir/release.ini
  local application_name=$(get-ini-value ApplicationName $ini_file)
  local app_image=$APP_IMAGE/$application_name.AppImage

  sudo mkdir -p $APP_IMAGE

  $project_dir/build.sh

  source $builder_dir/build-jvm-based-app-image.sh
  build-jvm-based-app-image $ini_file $builder_dir/resources $cache_dir $app_image
}

function app-image-alias {
  local ini_file=$PWD/release.ini
  local application_name=$(get-ini-value ApplicationName $ini_file)
  echo "alias $application_name=\"$APP_IMAGE/$application_name.AppImage $@\"" > "$BASH_LOCAL/$application_name.sh"
}
