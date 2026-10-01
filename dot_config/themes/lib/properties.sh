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
  # Currently this only handles one level deep nestings
  if [[ $property == *.* ]]; then
    local parent="${property%%.*}"
    local child="${property#*.}"

    path="[\"$parent\", \"$child\"]"
  else
    path="[\"$property\"]"
  fi

  local exists=$(jq -r "getpath($path)" "$ACTIVEFILE")

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
  generate_configs
}
