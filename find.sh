function find-file
{
  find . -name "$@"
}

function find-dir
{
  find . -type d -name "$@"
}

function find-text
{
  grep -rIinH "$@"
}
