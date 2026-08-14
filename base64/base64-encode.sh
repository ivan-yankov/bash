function base64-encode {
  cmd-dsc "Encode a string to base64."
  cmd-arg value string "String to encode"
  cmd-example "base64-encode hello"
  cmd-parse "$@" || return $CMD_RC

  printf '%s' "$ARG_value" | base64
}
