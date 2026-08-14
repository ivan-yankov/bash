function base64-decode {
  cmd-dsc "Decode a base64 string."
  cmd-arg value string "String to decode"
  cmd-example "base64-decode aGVsbG8="
  cmd-parse "$@" || return $CMD_RC

  printf '%s' "$ARG_value" | base64 --decode
  echo
}
