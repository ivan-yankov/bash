function manually-installed-packages {
  cmd-dsc "List the packages that were installed manually."
  cmd-dsc "Packages pulled in only as dependencies are not shown."
  cmd-example "manually-installed-packages"
  cmd-parse "$@" || return $CMD_RC

  comm -23 \
    <(apt-mark showmanual | sort -u) \
    <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)
}
