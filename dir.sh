function dir-diff {
  is-defined $1 && is-defined $2 || return 1
  diff -qr $1 $2
}
