function ft {
  cmd-dsc "Find text in the current directory recursively, interactively."
  cmd-dsc "Requires rg, fzf and optionally bat."
  cmd-arg query string = "Initial search phrase"
  cmd-example "ft"
  cmd-example "ft TODO"
  cmd-parse "$@" || return $CMD_RC

  rg --color=always --line-number --no-heading --smart-case "$ARG_query" 2>/dev/null | \
    fzf --ansi \
        --delimiter : \
        --preview 'bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || cat {1}' \
        --preview-window 'right:60%:+{2}-5'
}
