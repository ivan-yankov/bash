function lsar {
  cmd-dsc "Show the contents of an archive."
  cmd-dsc "The archive file extension selects the format."
  cmd-dsc "Supported formats: zip, tar, tar.gz (also .tgz)."
  cmd-arg archive file "Archive file to list"
  cmd-example "lsar backup.tar.gz"
  cmd-parse "$@" || return $CMD_RC

  case "$ARG_archive" in
    *.tar.gz|*.tgz) tar -ztf "$ARG_archive" ;;
    *.tar)          tar -tf  "$ARG_archive" ;;
    *.zip)          unzip -l "$ARG_archive" ;;
    *)
      printf 'lsar: Unsupported archive type: %s\n' "$ARG_archive" >&2
      return 2
      ;;
  esac
}
