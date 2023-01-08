# fixes hotkeys in xorg used in linux ubuntu
# due to bug introduced hotkeys trigger happens
# on key-press instead of key-release
# this prevents hotkeys with more than two keys
# to work properly
# https://launchpad.net/~nrbrtx/+archive/ubuntu/xorg-hotkeys
function fix-xorg-hotkeys {
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

function fix-xorg-hotkeys-remove-ppa {
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

  sudo rm /usr/bin/editor
  sudo ln -s $dir/micro /usr/bin/editor

  sudo rm /usr/bin/view
  sudo ln -s $dir/micro /usr/bin/view
}

function uninstall-micro {
  is-defined $PROGRAMS || return 1

  sudo rm /usr/bin/editor
  sudo ln -s /bin/nano /usr/bin/editor

  sudo rm /usr/bin/view
  sudo ln -s /bin/nano /usr/bin/view

  sudo rm -rf $PROGRAMS/micro
}

function install-mc {
  sudo apt install mc
  mkdir -p ~/.config/mc
  cp $(dirname $BASH_SOURCE)/resources/mc/* ~/.config/mc
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
