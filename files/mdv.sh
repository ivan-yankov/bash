# dsc:Render MarkDown file in the console.
# arg:$1 file to be rendered
function mdv {
  is-defined $1 || return 1
  pandoc $1 | lynx -stdin
}
