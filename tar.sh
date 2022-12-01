function mktar {
  tar -cvf "$@"
}

function untar {
  tar -xvf "$@"
}

function mktargz {
  tar -cvzf "$@"
}

function untargz
{
  tar -xvzf "$@"
}

function lstar
{
  tar -tf "$@"
}

function lstargz {
  tar -ztf "$@"
}

function tar-root {
  is-defined $1 || return 1
  lstar $1 | head -1 | cut -f1 -d "/"
}

function targz-root {
  is-defined $1 || return 1
  lstargz $1 | head -1 | cut -f1 -d "/"
}
