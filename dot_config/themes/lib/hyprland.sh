generate_hyprland_config() {
  local file="$XDG_CONFIG_HOME/hypr/theming.lua"

  log "Going to create $file."

  local no_rounding=$(jq -r '.hypr.noRounding' "$ACTIVEFILE")
  local decorate=$(jq -r '.hypr.decorate' "$ACTIVEFILE")
  local no_border=$(jq -r '.hypr.noBorder' "$ACTIVEFILE")

  local border_size=$(jq -r '.hypr.borderSize' "$ACTIVEFILE")

  local rounding=$(jq -r '.hypr.rounding' "$ACTIVEFILE")
  local rounding_power=$(jq -r '.hypr.roundingPower' "$ACTIVEFILE")

  local gaps_in=$(jq -r '.hypr.gapsIn' "$ACTIVEFILE")
  local gaps_out=$(jq -r '.hypr.gapsOut' "$ACTIVEFILE")

  printf '%s\n' \
    'hl.config({' \
    $'\t'"general = {" \
    $'\t\t'"border_size = $border_size," \
    $'\t\t'"gaps_in = $gaps_in," \
    $'\t\t'"gaps_out = $gaps_out," \
    $'\t'"}," \
    $'\t'"decoration = {" \
    $'\t\t'"rounding = $rounding," \
    $'\t\t'"rounding_power = $rounding_power," \
    $'\t'"}" \
    "})" \
    "" \
    "hl.workspace_rule({" \
    $'\t'"workspace = ''," \
    $'\t'"no_rounding = $no_rounding," \
    $'\t'"decorate = $decorate," \
    $'\t'"no_border = $no_border," \
    "})" >"$file"

  local file="$XDG_CONFIG_HOME/hypr/theming.conf"

  log "Going to create $file"

  printf '%s\n' \
    "\$font = $font_family" >$file
}
