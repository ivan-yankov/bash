# dsc:Show list of custom functions.
# env:$BASH_LOCAL directory which contains bash files specific to the local machine
function cmds {
  collect-cmds $(dirname $BASH_SOURCE)
  collect-cmds $BASH_LOCAL
}
