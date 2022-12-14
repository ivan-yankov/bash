function release-app-image {
  local project_dir=$PWD
  local cache_dir=~/.app-image-builder/cache

  source $(dirname $(dirname $BASH_SOURCE))/app-image-builder/build-jvm-based-app-image.sh

  sudo mkdir -p $APP_IMAGE

  $project_dir/build.sh && \

  for ini_file in $project_dir/*.ini; do
    local application_name=$(get-ini-value ApplicationName $ini_file)
    local app_image=$APP_IMAGE/$application_name.AppImage

    build-jvm-based-app-image $ini_file $builder_dir/resources $cache_dir $app_image && \
    app-image-alias $application_name
  done
}

function app-image-alias {
  is-defined $1 || return 1
  local application_name=$1
  local out=$BASH_LOCAL/$application_name.sh
  if [ ! -f $out ]; then
    echo "alias $application_name=\"$APP_IMAGE/$application_name.AppImage \"" > $out
  fi
}
