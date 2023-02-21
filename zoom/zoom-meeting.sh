# dsc:Start zoom messenger and join meeting.
# arg:$1 meeting url
function zoom-meeting {
  is-defined $1 || return 1
  pkill zoom
  zoom --url=$1 &
}
