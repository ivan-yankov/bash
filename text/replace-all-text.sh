function help-replace-all-text {
  echo "Replace text in all files in the current directory recursively."
  echo "Text match is case sensitive."
  echo
  echo "Usage: replace-all-text <what> <with>"
}

function replace-all-text {
  if [[ $# -lt 2 || $1 == "-h" ]]; then
    help-replace-all-text
    return $([[ $1 == "-h" ]] && echo 0 || echo 1)
  fi

  local WHAT=$1
  local WITH=$2

  if command -v sd &>/dev/null; then
    # Find matching files with ripgrep, then replace literally using sd
    rg -lF "$WHAT" | xargs -r sd -s "$WHAT" "$WITH"
  else
    # Pure cross-platform fallback using Perl (works on macOS + Ubuntu out of the box)
    rg -lF "$WHAT" | xargs -r perl -pi -e "s/\Q$WHAT\E/$WITH/g"
  fi
}
