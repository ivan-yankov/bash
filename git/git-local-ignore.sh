function help-git-local-ignore {
  echo "Git ignore files locally."
  echo "Files to ignore are listed in .git-local-ignore file in the project (git root) directory."
  echo
  echo "Usage: git-local-ignore flag"
  echo "  flag: true to ignore files locally, false otherwise"
}

function git-local-ignore {
  if [  $# -eq 0  ]; then
    help-git-local-ignore
    return 1
  fi

  if [[  $1 == "-h"  ]]; then
    help-git-local-ignore
    return 0
  fi

  local files=$(cat .git-local-ignore)

  local project_dir=~/data/repos/epg
  local exclude_file=$project_dir/.git/info/exclude
  local flag=$1

  > $exclude_file

  case $flag in
    true)
      for file in ${files[@]}; do
        echo $file >> $exclude_file
      done
      for file in ${files[@]}; do
        printf "Ignoring file %s\n" $file
        git update-index --skip-worktree $file
      done
      ;;
    false)
      for file in ${files[@]}; do
        printf "Stop ignoring file %s\n" $file
        git update-index --no-skip-worktree $file
      done
      ;;
    *)
      printf "Unsupported flag %s\n" $flag
      ;;
  esac
}
