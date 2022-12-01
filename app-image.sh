function release-app-image {
  is-defined $REPOS || return 1

  builder_dir=$REPOS/app-image-builder
  project_dir=$PWD
  cache_dir=~/.app-image-builder/cache

  $project_dir/build.sh

  source $builder_dir/build-jvm-based-app-image.sh
  build-jvm-based-app-image $project_dir/app-image.ini $builder_dir/resources $cache_dir

  cd $project_dir
}
