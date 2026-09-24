#!/bin/bash

log() {
  echo "[THEMES] $1"
}

THEMESDIR="$XDG_CONFIG_HOME/themes"
CACHEDIR="$XDG_CACHE_HOME/themes"

ACTIVEFILE="$THEMESDIR/active.json"

# This function will set relevant properties
# Then it will apply them to necessary applications
set_theme() {
  local theme=${1,,}

  if [[ ! -f "$THEMESDIR/$theme.json" ]]; then
    log "Theme $theme not found in $THEMESDIR"
    exit 1
  fi

  # I think copying the real theme json to active is enough for now
  log "Setting $theme as active"

  cp "$THEMESDIR/$theme.json" "$ACTIVEFILE"

  generate_configs all
}

get_theme() {
  if [[ -f $ACTIVEFILE ]]; then
    local active=$(jq -r '.name' "$ACTIVEFILE")

    echo "$active"
  else
    log "No theme set."
  fi
}

# This will basically fetch all possible themes
fetch_themes() {
  local themes=()
	local bin="$XDG_DATA_HOME/../bin/theme-configurator.sh"

  for file in "$THEMESDIR"/*.json; do
    [[ "$(basename "$file")" == "active.json" ]] && continue

		themes+=("$(jq -c --arg bin $bin '{name, path, command: ($bin + " set_theme " + .name)}' "$file")")
  done

  jq -s '.' <<<"$(printf '%s\n' "${themes[@]}")"
}

# This will override specific properties with a provided value
override_property() {
  local property="$1"
  local mode="$2"
  local value="$3"

  if [[ -z $property || -z $mode || -z $value ]]; then
    log "Provide a property, a jsonargument mode, and a value."
    exit 1
  fi

  local path=""

  # Check if it's nested
  if [[ $property == *.* ]]; then
    local parent="${property%%.*}"
    local child="${property#*.}"

    path="[\"$parent\", \"$child\"]"
  else
    path="[\"$property\"]"
  fi

  local exists=$(jq -r "getpath($path)" $ACTIVEFILE)

  if [[ $exists == "null" ]]; then
    log "The property $path doesn't seem to exist!"
    exit 1
  fi

  log "Setting value $value for property $property"

  # Distinguish between json arguments or strings
  case "$mode" in
  arg) jq --argjson path "$path" --arg value "$value" 'setpath($path; $value)' "$ACTIVEFILE" >"$THEMESDIR/temp.json" ;;
  argjson) jq --argjson path "$path" --argjson value "$value" 'setpath($path; $value)' "$ACTIVEFILE" >"$THEMESDIR/temp.json" ;;
  *)
    log "Invalid argument mode: $mode"
    exit 1
    ;;
  esac

  if [[ $? -eq 0 ]]; then
    log "Seems jq command went fine, proceeding."
    mv "$THEMESDIR/temp.json" "$ACTIVEFILE"
  fi

  # Generate configurations for all applications with new values
  generate_configs all
}

generate_configs() {
  local application="$1"

  mkdir -p "$XDG_CACHE_HOME/themes"

  case "$application" in
  hyprland) generate_hyprland_config ;;
	dunst) generate_dunst_config ;;
  *)
    generate_hyprland_config
		generate_dunst_config
    ;;
  esac
}

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
}

generate_dunst_config() {
	local file="$XDG_CONFIG_HOME/dunst/dunstrc.d/99-theming.conf"

	log "Going to create $file"

	mkdir -p "$XDG_CONFIG_HOME/dunst/dunstrc.d"

	local background=$(cat "$XDG_CACHE_HOME/wal/colors" | head -n 1)
	local transparency=$(printf '%02X' $(jq -r '.transparency * 255 | round' "$ACTIVEFILE"))

	local font_family=$(jq -r '.fontFamily' "$ACTIVEFILE")
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
		$'\t'"background = \"${background}${transparency}\"" \
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
	nohup dunstctl reload >/dev/null 2>&1 &
}

reload_apps() {
  log "Reloading applications, bla bla bla"
}

case "$1" in
set_theme) set_theme "$2" ;;
get_theme) get_theme "$2" ;;
fetch_themes) fetch_themes ;;
override_property) override_property "$2" "$3" "$4" ;;
generate_configs) generate_configs "$2" ;;
reload_apps) reload_apps ;;
esac
