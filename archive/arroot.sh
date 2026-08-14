function arroot {
  cmd-dsc "Get the name of the archive's root directory."
  cmd-dsc "Supported formats: zip, tar, tar.gz (also .tgz)."
  cmd-arg archive file "Archive file to inspect"
  cmd-example "arroot backup.tar.gz"
  cmd-parse "$@" || return $CMD_RC

  lsar -- "$ARG_archive" | head -1 | cut -f1 -d "/"
}
