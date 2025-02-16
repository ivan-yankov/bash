function help-build-ffmpeg-custom {
  echo "Build ffmpeg with nvidia nvenc encoder engine support."
  echo "This allows to convert video files using hardware acceleration."
  echo "Uses environment variable REPOS_PATH."
  echo
  echo "Usage: build-ffmpeg-nvenc"
}

function build-ffmpeg-custom {
  if [[  $1 == "-h"  ]]; then
    help-build-ffmpeg-custom
    return 0
  fi

  echo "=== Updating system and installing dependencies ==="
  sudo apt update
  sudo apt -y install \
    autoconf automake build-essential cmake git libass-dev libfreetype6-dev \
    libgnutls28-dev libtool libvorbis-dev libxcb1-dev libxcb-shm0-dev \
    libxcb-xfixes0-dev meson ninja-build pkg-config texinfo wget yasm zlib1g-dev \
    libunistring-dev libva-dev libvdpau-dev libdrm-dev libssl-dev libdav1d-dev

  cd $REPOS_PATH

  echo "=== Installing NVIDIA codec headers (NVENC) ==="
  sudo rm -rf /usr/local/include/nvEncodeAPI.h
  sudo rm -rf /usr/local/lib/libnvidia-encode*
  if [ -d "nv-codec-headers" ]; then
    rm -rf nv-codec-headers
  fi
  git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
  cd nv-codec-headers
  git checkout n12.1.14.0
  make
  sudo make install

  cd $REPOS_PATH

  echo "=== Cloning latest FFmpeg ==="
  if [ -d "ffmpeg" ]; then
    rm -rf ffmpeg
  fi
  git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
  cd ffmpeg
  git checkout n6.0.0
  make distclean

  echo "=== Configuring FFmpeg with NVENC support ==="
  export CFLAGS="-I/usr/local/include -DNVENCAPI_VER=12"
  export LDFLAGS="-L/usr/local/lib"
  ./configure \
    --prefix=/usr/local \
    --disable-shared \
    --enable-static \
    --enable-small \
    --enable-gpl \
    --enable-nonfree \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libvpx \
    --enable-libfdk-aac \
    --enable-libopus \
    --enable-libvorbis \
    --enable-libass \
    --enable-libfreetype \
    --enable-libfribidi \
    --enable-libdrm \
    --enable-nvenc \
    --enable-nvdec \
    --enable-libdav1d

  echo "=== Building FFmpeg (this may take a while) ==="
  make -j"$(nproc)"

  echo "=== Installing FFmpeg ==="
  sudo make install

  echo "=== Done ==="
}
