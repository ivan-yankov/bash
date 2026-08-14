function zoom-meeting {
  cmd-dsc "Restart the zoom client and join a meeting."
  cmd-arg url string "Meeting url"
  cmd-example "zoom-meeting https://zoom.us/j/123456789"
  cmd-parse "$@" || return $CMD_RC

  pkill zoom
  zoom --url="$ARG_url" &
}
