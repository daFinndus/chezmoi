# This will basically generate all necessary files
# This is so no errors are happening
# The checks here are super bad, but they work for now
init() {
  # This is necessary to set the initial common properties
  refetch_properties

  declare -A configs=(
    ["$XDG_CONFIG_HOME/hypr/theming.lua"]='generate_hyprland_config'
    ["$XDG_CONFIG_HOME/dunst/dunstrc.d/99-theming.conf"]='generate_dunst_config'
    ["$XDG_CONFIG_HOME/kitty/theming.conf"]='generate_kitty_config'
    ["$XDG_CONFIG_HOME/rofi/theming.rasi"]='generate_rofi_config'
  )

  for file in "${!configs[@]}"; do
    if [[ ! -f $file ]]; then
      log "$file doesn't exist yet.. generating."
      "${configs[$file]}"
    else
      log "$file already exists. Nice!"
    fi
  done

  # This is not a specific config, so gotta check it this way
  local font=$(gsettings get org.gnome.desktop.interface font-name | sed "s/^'//;s/'$//")
  local dark=$(gsettings get org.gnome.desktop.interface color-scheme | sed "s/^'//;s/'$//")

  if [[ $font == "$font_family 10" && $dark == "prefer-dark" ]]; then
    log "System properties seem to be applied."
  else
    apply_system_properties
  fi
}
