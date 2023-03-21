# dsc:Build AppImage.
# dsc:Expects build.sh script in project directory. It is used to build the project code base.
# dsc:Expects ini file(s) to be defined with build details.
# arg:$1 project directory
# arg:$2 AppImage destination directory
function app-image-build {
  is-defined $1 && is-defined $2 || return 1

  local project_dir=$1
  local app_image_dir=$2
  local cache_dir=~/.app-image-builder/cache

  sudo mkdir -p $app_image_dir

  $project_dir/build.sh && \

  for ini_file in $project_dir/*.ini; do
    local application_name=$(get-ini-value ApplicationName $ini_file)
    local app_image=$app_image_dir/$application_name.AppImage

    app-image-build-jvm-based $ini_file $cache_dir $app_image
  done
}
