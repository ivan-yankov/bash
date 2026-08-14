function html-player {
  cmd-dsc "Play a webm or mp4 file in the browser, so it can be cast."
  cmd-dsc "Chromium is used because it can cast, but it can only read files"
  cmd-dsc "under the home directory, so the page is written there."
  cmd-arg file file "Video file to play"
  cmd-example "html-player holiday.mp4"
  cmd-parse "$@" || return $CMD_RC

  local path ext html_file
  path=$(realpath "$ARG_file")
  ext=$(file-ext "$path")
  html_file=~/html-player.html

  cat > "$html_file" <<HTML
<html><body style="background-color:black;">
<video width="100%" height="100%" controls>
<source src="$path" type="video/$ext">
</video></body></html>
HTML

  chromium "$html_file" &
}
