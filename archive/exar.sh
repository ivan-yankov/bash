function exar {
  cmd-dsc "Extract an archive."
  cmd-dsc "The archive file extension selects the format."
  cmd-dsc "Supported formats: zip, tar, tar.gz (also .tgz)."
  cmd-arg archive file "Archive file to extract"
  cmd-arg target dir =. "Directory to extract into"
  cmd-example "exar backup.tar.gz"
  cmd-example "exar photos.zip ./restored"
  cmd-parse "$@" || return $CMD_RC

  case "$ARG_archive" in
    *.tar.gz|*.tgz) tar -xvzf "$ARG_archive" -C "$ARG_target" ;;
    *.tar)          tar -xvf  "$ARG_archive" -C "$ARG_target" ;;
    *.zip)          unzip     "$ARG_archive" -d "$ARG_target" ;;
    *)
      printf 'exar: Unsupported archive type: %s\n' "$ARG_archive" >&2
      return 2
      ;;
  esac
}
