# dsc:Remove micro text editor and set text editor to nano.
function remove-micro {
  sudo ln -sf /bin/nano /usr/bin/te
  sudo rm -rf /opt/micro
}
