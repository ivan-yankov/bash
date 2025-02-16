function help-build-ffmpeg-nvenc {
  echo "Build ffmpeg with nvidia nvenc encoder engine support."
  echo "This allows to convert video files using hardware acceleration."
  echo
  echo "Usage: build-ffmpeg-nvenc"
}

function build-ffmpeg-nvenc {
  if [[  $1 == "-h"  ]]; then
    help-build-ffmpeg-nvenc
    return 0
  fi

  echo "=== Updating system and installing dependencies ==="
  sudo apt update
  sudo apt -y install \
    autoconf automake build-essential cmake git libass-dev libfreetype6-dev \
    libgnutls28-dev libtool libvorbis-dev libxcb1-dev libxcb-shm0-dev \
    libxcb-xfixes0-dev meson ninja-build pkg-config texinfo wget yasm zlib1g-dev \
    libunistring-dev libva-dev libvdpau-dev libdrm-dev libssl-dev
  
  echo "=== Installing NVIDIA codec headers (NVENC) ==="
  if [ -d "nv-codec-headers" ]; then
    rm -rf nv-codec-headers
  fi
  git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
  cd nv-codec-headers
  make
  sudo make install
  cd ..

  echo "=== Cloning latest FFmpeg ==="
  if [ -d "ffmpeg" ]; then
    rm -rf ffmpeg
  fi
  git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
  cd ffmpeg

  make distclean

  echo "=== Configuring FFmpeg with NVENC support ==="
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
    --extra-cflags=-I/usr/local/include \
    --extra-ldflags=-L/usr/local/lib

  echo "=== Building FFmpeg (this may take a while) ==="
  make -j"$(nproc)"

  echo "=== Installing FFmpeg ==="
  sudo make install

  echo "=== Verify NVENC support (output should contain V..... h264_nvenc, V..... hevc_nvenc) ==="
  ffmpeg -encoders | grep nvenc

  echo "=== Done ==="
}
