# dsc:Remove micro text editor and set text editor to nano.
function remove-micro {
  sudo ln -sf /bin/nano /usr/bin/editor
  sudo ln -sf /bin/nano /usr/bin/te
  sudo ln -sf /bin/nano /usr/bin/view

  sudo rm -rf /opt/micro
}
