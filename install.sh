# fixes hotkeys in xorg used in linux ubuntu
# due to bug introduced hotkeys trigger happens
# on key-press instead of key-release
# this prevents hotkeys with more than two keys
# to work properly
# https://launchpad.net/~nrbrtx/+archive/ubuntu/xorg-hotkeys
function install-xorg-hotkeys-fix {
  sudo apt-add-repository ppa:nrbrtx/xorg-hotkeys
  sudo apt update
  sudo apt dist-upgrade

  # pin version to avoid upgrade
  f=/etc/apt/preferences.d/pin-xorg-hotkeys
  sudo touch $f
  sudo echo "Package: *" >> $f
  sudo echo "Pin: release o=LP-PPA-nrbrtx-xorg-hotkeys" >> $f
  sudo echo "Pin-Priority: 1337" >> $f
}

function remove-xorg-hotkeys-fix {
  sudo apt install ppa-purge
  sudo rm /etc/apt/preferences.d/pin-xorg-hotkeys
  sudo ppa-purge ppa:nrbrtx/xorg-hotkeys
}

function install-audacity {
  sudo add-apt-repository ppa:ubuntuhandbook1/audacity
  sudo apt update
  sudo apt install audacity
}

function install-flac {
  sudo apt install flac
}

function install-tesseract {
  sudo apt install -y tesseract-ocr
  sudo apt install -y tesseract-ocr-bul
  sudo apt install -y tesseract-ocr-rus
}

function install-openjfx {
  sudo apt install openjfx=8u161-b12-1ubuntu2 libopenjfx-java=8u161-b12-1ubuntu2 libopenjfx-jni=8u161-b12-1ubuntu2
  sudo apt-mark hold openjfx libopenjfx-java libopenjfx-jni
}

function install-micro {
  is-defined $PROGRAMS || return 1
  local dir=$PROGRAMS/micro

  sudo apt install xclip
  sudo mkdir -p $dir
  sudo curl -sL https://gist.githubusercontent.com/zyedidia/d4acfcc6acf2d0d75e79004fa5feaf24/raw/a43e603e62205e1074775d756ef98c3fc77f6f8d/install_micro.sh | sudo bash -s linux64 $dir
}

function remove-micro {
  is-defined $PROGRAMS || return 1

  sudo ln -sf /bin/nano /usr/bin/editor
  sudo ln -sf /bin/nano /usr/bin/view

  sudo rm -rf $PROGRAMS/micro
}

function install-virtualbox {
  sudo add-apt-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
  wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
  wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
  sudo apt update
  sudo apt install -y virtualbox-6.1
}

function install-nodejs {
  curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
  sudo apt update
  sudo apt install -y nodejs
}

function install-systemback {
  sudo add-apt-repository
  sudo apt-get install software-properties-common
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 382003C2C8B7B4AB813E915B14E4942973C62A1B
  sudo add-apt-repository "deb http://ppa.launchpad.net/nemh/systemback/ubuntu xenial main"
  sudo apt update
  sudo apt install systemback
}

function app-links {
  is-defined $PROGRAMS || return 1

  sudo ln -sf $PROGRAMS/micro/micro /usr/bin/editor
  sudo ln -sf $PROGRAMS/micro/micro /usr/bin/view
  sudo ln -sf /usr/bin/krita /usr/bin/image-editor
  sudo ln -sf /usr/bin/gwenview /usr/bin/image-viewer
  sudo ln -sf /usr/bin/vlc /usr/bin/audio-player
  sudo ln -sf /usr/bin/vlc /usr/bin/video-player
  sudo ln -sf /usr/bin/libreoffice /usr/bin/office
  sudo ln -sf /usr/bin/okular /usr/bin/pdf-viewer
  sudo ln -sf /usr/bin/remarkable /usr/bin/markdown
}
