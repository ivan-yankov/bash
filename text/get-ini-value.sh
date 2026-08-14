function get-ini-value {
  cmd-dsc "Read a value from an .ini file."
  cmd-arg key string "Key to look up"
  cmd-arg file file "The .ini file to read"
  cmd-example "get-ini-value ApplicationName app.ini"
  cmd-parse "$@" || return $CMD_RC

  awk -F= -v key="$ARG_key" '$1 == key { print $2 }' "$ARG_file"
}
