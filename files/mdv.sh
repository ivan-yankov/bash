function mdv {
  cmd-dsc "Render a Markdown file in the console."
  cmd-arg file file "Markdown file to render"
  cmd-example "mdv README.md"
  cmd-parse "$@" || return $CMD_RC

  pandoc "$ARG_file" | lynx -stdin
}
