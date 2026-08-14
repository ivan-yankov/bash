function title {
  cmd-dsc "Set the title of the current terminal tab."
  cmd-arg text string "Title to set"
  cmd-example "title build"
  cmd-parse "$@" || return $CMD_RC

  printf '\033]30;%s\007' "$ARG_text"
}
