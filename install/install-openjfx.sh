# dsc:Install open JavaFx.
function install-openjfx {
  sudo apt install openjfx=8u161-b12-1ubuntu2 libopenjfx-java=8u161-b12-1ubuntu2 libopenjfx-jni=8u161-b12-1ubuntu2
  sudo apt-mark hold openjfx libopenjfx-java libopenjfx-jni
}
