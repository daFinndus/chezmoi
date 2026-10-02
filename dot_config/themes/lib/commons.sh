# Fetch all common properties that are used by multiple scripts

font_family=""
font_size=""

transparency_decimal=""
transparency_hex=""

background_index=""
background_color=""

shade_index=""
shade_color=""

animation_duration=""

# This is basically so default values are re-fetched
# Necessary so configuration changes will not be skipped
refetch_properties() {
  font_family=$(get_property '.fontFamily')
  font_size=$(get_property '.fontSize')

  transparency_decimal=$(get_property '.transparency')
  transparency_hex=$(printf '%02X' $(jq -r '.transparency * 255 | round' "$ACTIVEFILE"))

  background_index=$(get_property '.background')
  background_color=$(sed -n "$((background_index + 1))p" "$XDG_CACHE_HOME/wal/colors")

  shade_index=$(get_property '.shade')
  shade_color=$(sed -n "$((shade_index + 1))p" "$XDG_CACHE_HOME/wal/colors")

  animation_duration=$(get_property '.animationDuration')
}

# Will return specified property
get_property() {
  local key="$1"
  jq -r "$key" "$ACTIVEFILE"
}
