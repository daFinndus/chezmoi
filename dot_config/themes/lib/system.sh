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

  # True is necessary here, because it would basically stop the whole script otherwise
  pkill -HUP xsettingsd || true
}
