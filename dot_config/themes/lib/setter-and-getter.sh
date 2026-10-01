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

  generate_configs
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
    themes+=("$(jq -c --arg bin "$bin" '{name, path, command: ($bin + " set_theme " + .name)}' "$file")")
  done

  jq -s '.' <<<"$(printf '%s\n' "${themes[@]}")"
}
