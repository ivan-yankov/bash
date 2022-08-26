function tar-root {
  lstar $1 | head -1 | cut -f1 -d "/"
}

function targz-root {
  lstargz $1 | head -1 | cut -f1 -d "/"
}
