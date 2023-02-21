# dsc:Install docker.
function docker-install {
  # update the apt package index and install packages to allow apt to use a repository over https
  sudo apt update
  sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

  # add docker official gpg key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  # setup stable repositopry
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

  # install docker engine
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io

  sudo usermod -a -G docker $USER

  echo
  echo "Docker installation completed"
  echo "Reboot the system"
}
