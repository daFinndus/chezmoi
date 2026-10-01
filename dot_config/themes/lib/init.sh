# This will basically generate all necessary files
# This is so no errors are happening
init() {
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
}
