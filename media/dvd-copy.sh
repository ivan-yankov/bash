function dvd-copy {
  cmd-dsc "Copy the VIDEO_TS directory of a DVD into a local directory."
  cmd-dsc "Mounts the optical drive at /mnt/cdrom while copying."
  cmd-arg target string "Directory to copy into; created if missing"
  cmd-example "dvd-copy ./my-film"
  cmd-parse "$@" || return $CMD_RC

  mnt-cdrom || return

  local src=/mnt/cdrom
  mkdir -p "$ARG_target"
  sudo cp -r "$src/VIDEO_TS" "$ARG_target"
  sudo chmod +rwx "$ARG_target/VIDEO_TS/"

  umnt-cdrom
}
