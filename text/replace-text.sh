function replace-text {
  cmd-dsc "Replace text in a file. The match is case sensitive and literal."
  cmd-arg what string "Text to replace"
  cmd-arg with string "Replacement text"
  cmd-arg file file "File to modify"
  cmd-example "replace-text quick slow sample.txt"
  cmd-parse "$@" || return $CMD_RC

  if command -v sd &>/dev/null; then
    # -s treats the input as a literal string, so nothing needs escaping.
    sd -s "$ARG_what" "$ARG_with" "$ARG_file"
  else
    # Cross-platform perl fallback when sd is not installed. \Q..\E quotes the
    # pattern so it stays literal.
    perl -pi -e 'BEGIN { ($w, $r) = @ARGV; splice(@ARGV, 0, 2) } s/\Q$w\E/$r/g' \
      "$ARG_what" "$ARG_with" "$ARG_file"
  fi
}
