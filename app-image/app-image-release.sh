# dsc:Build .AppImage file from the project directory.
# dsc:Expects .ini file(s) to be defined with build details.
# env:$PROGRAMS path to the programs directory
# arg:$1 project directory
function app-image-release {
  is-defined $PROGRAMS && is-defined $1 || return 1

  local project_dir=$1
  local cache_dir=~/.app-image-builder/cache
  local app_image_dir=$PROGRAMS/app-image

  source $(dirname $(dirname $BASH_SOURCE))/app-image-builder/build-jvm-based-app-image.sh

  sudo mkdir -p $app_image_dir

  $project_dir/build.sh && \

  for ini_file in $project_dir/*.ini; do
    local application_name=$(get-ini-value ApplicationName $ini_file)
    local app_image=$app_image_dir/$application_name.AppImage

    build-jvm-based-app-image $ini_file $cache_dir $app_image
  done
}