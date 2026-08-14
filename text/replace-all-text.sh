function replace-all-text {
  cmd-dsc "Replace text in every file in the current directory recursively."
  cmd-dsc "The match is case sensitive and literal. Requires rg."
  cmd-arg what string "Text to replace"
  cmd-arg with string "Replacement text"
  cmd-example "replace-all-text quick slow"
  cmd-parse "$@" || return $CMD_RC

  if command -v sd &>/dev/null; then
    rg -lF "$ARG_what" | xargs -r sd -s "$ARG_what" "$ARG_with"
  else
    rg -lF "$ARG_what" | xargs -r perl -pi -e \
      'BEGIN { ($w, $r) = @ARGV; splice(@ARGV, 0, 2) } s/\Q$w\E/$r/g' \
      "$ARG_what" "$ARG_with"
  fi
}
