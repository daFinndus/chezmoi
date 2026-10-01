generate_dunst_config() {
  local file="$XDG_CONFIG_HOME/dunst/dunstrc.d/99-theming.conf"

  log "Going to create $file"

  mkdir -p "$XDG_CONFIG_HOME/dunst/dunstrc.d"

  local font_size=$(jq -r '.dunst.fontSize' "$ACTIVEFILE")

  local line_height=$(jq -r '.dunst.lineHeight' "$ACTIVEFILE")
  local separator_height=$(jq -r '.dunst.separatorHeight' "$ACTIVEFILE")

  local padding=$(jq -r '.dunst.padding' "$ACTIVEFILE")
  local horizontal_padding=$(jq -r '.dunst.horizontalPadding' "$ACTIVEFILE")

  local frame_width=$(jq -r '.dunst.frameWidth' "$ACTIVEFILE")
  local corner_radius=$(jq -r '.dunst.cornerRadius' "$ACTIVEFILE")

  printf '%s\n' \
    '[global]' \
    $'\t'"font = $font_family $font_size" \
    "" \
    $'\t'"background = \"${background_color}${transparency_hex}\"" \
    "" \
    $'\t'"line_height = $line_height" \
    $'\t'"separator_height = $separator_height" \
    "" \
    $'\t'"padding = $padding" \
    $'\t'"horizontal_padding = $horizontal_padding" \
    "" \
    $'\t'"frame_width = $frame_width" \
    $'\t'"corner_radius = $corner_radius" >"$file"

  # Reload dunst without interrupting script flow
  # True is necessary here, because it could stop the script otherwise
  nohup dunstctl reload >/dev/null 2>&1 || true
}
