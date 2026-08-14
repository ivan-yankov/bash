function build-ffmpeg-custom {
  cmd-dsc "Build ffmpeg with NVIDIA nvenc support, for hardware accelerated"
  cmd-dsc "video conversion. Sources are cloned under REPOS_DIR."
  cmd-env REPOS_DIR "Directory the sources are cloned into"
  cmd-example "build-ffmpeg-custom"
  cmd-parse "$@" || return $CMD_RC

  if [ -z "${REPOS_DIR:-}" ] || [ ! -d "$REPOS_DIR" ]; then
    echo "build-ffmpeg-custom: REPOS_DIR is not set to an existing directory" >&2
    return 1
  fi

  echo "=== Updating system and installing dependencies ==="
  sudo apt update
  sudo apt -y install \
    autoconf automake build-essential cmake git libass-dev libfreetype6-dev \
    libgnutls28-dev libtool libvorbis-dev libxcb1-dev libxcb-shm0-dev \
    libxcb-xfixes0-dev meson ninja-build pkg-config texinfo wget yasm zlib1g-dev \
    libunistring-dev libva-dev libvdpau-dev libdrm-dev libssl-dev libdav1d-dev || return

  # A subshell keeps the caller's working directory intact.
  (
    cd "$REPOS_DIR" || exit 1

    echo "=== Installing NVIDIA codec headers (NVENC) ==="
    sudo rm -rf /usr/local/include/nvEncodeAPI.h
    sudo rm -rf /usr/local/lib/libnvidia-encode*
    rm -rf nv-codec-headers
    git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git || exit 1
    (
      cd nv-codec-headers || exit 1
      git checkout n12.1.14.0
      make
      sudo make install
    ) || exit 1

    echo "=== Cloning FFmpeg ==="
    rm -rf ffmpeg
    git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg || exit 1
    cd ffmpeg || exit 1
    git checkout n6.0.0
    make distclean

    echo "=== Configuring FFmpeg with NVENC support ==="
    export CFLAGS="-I/usr/local/include -DNVENCAPI_VER=12"
    export LDFLAGS="-L/usr/local/lib"
    ./configure \
      --prefix=/usr/local \
      --disable-shared --enable-static --enable-small \
      --enable-gpl --enable-nonfree \
      --enable-libx264 --enable-libx265 --enable-libvpx \
      --enable-libfdk-aac --enable-libopus --enable-libvorbis \
      --enable-libass --enable-libfreetype --enable-libfribidi \
      --enable-libdrm --enable-nvenc --enable-nvdec --enable-libdav1d || exit 1

    echo "=== Building FFmpeg (this may take a while) ==="
    make -j"$(nproc)" || exit 1

    echo "=== Installing FFmpeg ==="
    sudo make install
  ) || return

  echo "=== Done ==="
}
