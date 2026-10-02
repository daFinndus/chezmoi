generate_configs() {
  local application="${1:-}"

  # This is so current active.json is being read
  # Explicitly for the global properties like
  # Font family, size, etc. which is used my multiple
  # Application configurations
  refetch_properties

  case "$application" in
  system) apply_system_properties ;;
  hyprland) generate_hyprland_config ;;
  dunst) generate_dunst_config ;;
  kitty) generate_kitty_config ;;
  rofi) generate_rofi_config ;;
  *)
    apply_system_properties
    generate_hyprland_config
    generate_dunst_config
    generate_kitty_config
    generate_rofi_config
    ;;
  esac
}
