function release-app-image {
  dir=$PWD
  ./build.sh
  cd $REPOS/app-image-builder
  ./build-jvm-based-app-image.sh $dir
  cd $dir
}
