function help-replace-text {
  echo "Replace text in a specified file."
  echo "Text match is case sensitive."
  echo
  echo "Usage: replace-text <what> <with> <file>"
}

function replace-text {
  if [[ $# -lt 3 || $1 == "-h" ]]; then
    help-replace-text
    return $([[ $1 == "-h" ]] && echo 0 || echo 1)
  fi

  local WHAT=$1
  local WITH=$2
  local FILE=$3

  if command -v sd &>/dev/null; then
    # -s treats input as literal string (no regex escaping needed)
    sd -s "$WHAT" "$WITH" "$FILE"
  else
    # Cross-platform perl fallback if sd is not installed
    perl -pi -e 's/'"$(printf '%s' "$WHAT" | sed 's/[=\/&]/\\&/g')"'/'"$(printf '%s' "$WITH" | sed 's/[=\/&]/\\&/g')"'/' "$FILE"
  fi
}
