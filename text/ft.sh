function ft {
  cmd-dsc "Find text in the current directory recursively, interactively."
  cmd-dsc "Requires rg, fzf and optionally bat."
  cmd-arg query string = "Initial search phrase"
  cmd-example "ft"
  cmd-example "ft TODO"
  cmd-parse "$@" || return $CMD_RC

  rg --color=never --line-number --no-heading --smart-case "$ARG_query" 2>/dev/null |
    awk '{
      p = index($0, ":")
      file = substr($0, 1, p - 1)
      rest = substr($0, p + 1)
      q = index(rest, ":")
      line = substr(rest, 1, q - 1)
      text = substr(rest, q + 1)
      if (length(text) > 50) text = substr(text, 1, 50) "..."
      printf "%s\t%s\t%s\n", file, line, text
    }' |
    fzf --delimiter=$'\t' \
        --no-hscroll \
        --preview 'file=$(printf "%s" {1}); line={2}; bat --style=numbers --color=always --highlight-line "$line" -- "$file" 2>/dev/null || cat -- "$file"' \
        --preview-window 'right:60%:+{2}-1'
}
