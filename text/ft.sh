function help-ft {
  echo "Find text in the current directory recursively."
  echo
  echo "Usage: ft [search-phrase]"
}

function ft {
  if [[ $1 == "-h" ]]; then
    help-ft
    return 0
  fi

  local INITIAL_QUERY="${1:-}"

  rg --color=always --line-number --no-heading --smart-case "$INITIAL_QUERY" 2>/dev/null | \
  fzf --ansi \
      --delimiter : \
      --preview 'bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || cat {1}' \
      --preview-window 'right:60%:+{2}-5'
}
