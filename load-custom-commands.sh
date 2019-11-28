install_scripts_folder=$BASH_SCRIPTS/install

source $BASH_SCRIPTS/system/clean-system.sh
source $BASH_SCRIPTS/system/create-shortcut.sh

source $BASH_SCRIPTS/backup/backup-data.sh
source $BASH_SCRIPTS/backup/diff-data.sh
source $BASH_SCRIPTS/backup/syncdir.sh

source $BASH_SCRIPTS/docker/docker-clear.sh
source $BASH_SCRIPTS/docker/docker-install.sh
source $BASH_SCRIPTS/docker/docker-list.sh
source $BASH_SCRIPTS/docker/docker-prepare-installation.sh
source $BASH_SCRIPTS/docker/docker-remove-none-images.sh
source $BASH_SCRIPTS/docker/docker-uninstall.sh

source $BASH_SCRIPTS/install/install-audacity.sh
source $BASH_SCRIPTS/install/install-derby.sh
source $BASH_SCRIPTS/install/install-flac.sh
source $BASH_SCRIPTS/install/install-glassfish.sh
source $BASH_SCRIPTS/install/install-jdk.sh
source $BASH_SCRIPTS/install/install-mysql.sh
source $BASH_SCRIPTS/install/install-tesseract.sh
source $BASH_SCRIPTS/install/install-tomcat.sh

source $BASH_SCRIPTS/alias/sweet-home.sh