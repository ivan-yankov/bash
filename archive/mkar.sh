function mkar {
  cmd-dsc "Make an archive."
  cmd-dsc "The archive file extension selects the format."
  cmd-dsc "Supported formats: zip, tar, tar.gz (also .tgz)."
  cmd-arg archive newpath "Archive file to create"
  cmd-arg sources path... "Files and directories to put in the archive"
  cmd-example "mkar backup.tar.gz ~/data ~/notes"
  cmd-example "mkar photos.zip ./photos"
  cmd-parse "$@" || return $CMD_RC

  if [ ${#ARG_sources[@]} -eq 0 ]; then
    printf 'mkar: no files given to archive\n' >&2
    return 1
  fi

  case "$ARG_archive" in
    *.tar.gz|*.tgz) tar -cvzf "$ARG_archive" "${ARG_sources[@]}" ;;
    *.tar)          tar -cvf  "$ARG_archive" "${ARG_sources[@]}" ;;
    *.zip)          zip -r    "$ARG_archive" "${ARG_sources[@]}" ;;
    *)
      printf 'mkar: Unsupported archive type: %s\n' "$ARG_archive" >&2
      return 2
      ;;
  esac
}
