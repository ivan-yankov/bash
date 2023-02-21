# dsc:Show list of manually installed packages in the system.
# dsc:Do not show package dependecies.
function manually-installed-packages {
  comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)
}
