# dsc:Show list of custom functions / commands.
# env:$CMDS list of custom functions / commands built during loading sources
function cmds {
  is-defined $CMDS || return 1
  echo "$CMDS"
}
