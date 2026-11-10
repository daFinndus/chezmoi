apply_system_properties() {
  log "Going to set font and dark mode."

  local fontFamily=$(jq -r '.fontFamily' "$ACTIVEFILE")

  gsettings set org.gnome.desktop.interface font-name "$fontFamily 10"
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

  mkdir -p "$XDG_CONFIG_HOME/gtk-3.0"

  printf '%s\n' \
    "[Settings]" \
    "gtk-font-name=$fontFamily 10" \
    "gtk-application-prefer-dark-theme=1" >"$XDG_CONFIG_HOME/gtk-3.0/settings.ini"

  mkdir -p "$XDG_CONFIG_HOME/gtk-4.0"

  printf '%s\n' \
    "[Settings]" \
    "gtk-font-name=$fontFamily 10" \
    "gtk-application-prefer-dark-theme=1" >"$XDG_CONFIG_HOME/gtk-4.0/settings.ini"

  mkdir -p "$XDG_CONFIG_HOME/xsettingsd"

  printf '%s\n' \
    'Net/ThemeName "Adwaita-dark"' \
    "Gtk/FontName \"$fontFamily 10\"" >"$XDG_CONFIG_HOME/xsettingsd/xsettingsd.conf"

  mkdir -p "$XDG_CONFIG_HOME/xdg-desktop-portal"

  printf '%s\n' \
    '[preferred]' \
    'default = hyprland' \
    'org.freedesktop.impl.portal.Settings = gtk' >"$XDG_CONFIG_HOME/xdg-desktop-portal/hyprland-portals.conf"

  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"

  # Restart potentially necessary services
  systemctl --user restart xdg-desktop-portal xdg-desktop-portal-hyprland

  # True is necessary here, because it would basically stop the whole script otherwise
  pkill -HUP xsettingsd || true
}
