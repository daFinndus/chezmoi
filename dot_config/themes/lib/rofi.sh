generate_rofi_config() {
  local file="$XDG_CONFIG_HOME/rofi/theming.rasi"

  log "Going to create $file"

  local border_size=$(jq -r '.rofi.borderSize' "$ACTIVEFILE")
  local border_radius=$(jq -r '.rofi.borderRadius' "$ACTIVEFILE")

  printf '%s\n' \
    "* {" \
    $'\t'"background: $background_color;" \
    $'\t'"foreground: $shade_color;" \
    $'\t'"font: \"$font_family 10\";" \
    "}" \
    "" \
    "window {" \
    $'\t'"background-color: ${background_color}${transparency_hex};" \
    $'\t'"border: $border_size;" \
    $'\t'"border-radius: $border_radius;" \
    "}" >"$file"
}
