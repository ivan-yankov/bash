function install-openjfx {
  cmd-dsc "Install OpenJFX and hold it at a known version."
  cmd-example "install-openjfx"
  cmd-parse "$@" || return $CMD_RC

  sudo apt install -y \
    openjfx=8u161-b12-1ubuntu2 \
    libopenjfx-java=8u161-b12-1ubuntu2 \
    libopenjfx-jni=8u161-b12-1ubuntu2
  sudo apt-mark hold openjfx libopenjfx-java libopenjfx-jni
}
