# dsc:Remove micro text editor and set 'editor' and 'view' links to point to nano text editor.
function remove-micro {
  is-defined $PROGRAMS || return 1

  sudo ln -sf /bin/nano /usr/bin/editor
  sudo ln -sf /bin/nano /usr/bin/view

  sudo rm -rf $PROGRAMS/micro
}
