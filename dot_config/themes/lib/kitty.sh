generate_kitty_config() {
  local file="$XDG_CONFIG_HOME/kitty/theming.conf"

  log "Going to create $file"

  printf '%s\n' \
    "background_opacity"$'\t'"$transparency_decimal" >"$file"
}
