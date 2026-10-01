#!/bin/bash

# Basically checks for the following
# Unbound variables
# Errors in cli calls
# And aborts the script on unsuccessful cli calls
set -euo pipefail

THEMESDIR="$XDG_CONFIG_HOME/themes"
ACTIVEFILE="$THEMESDIR/active.json"

log() {
  echo "[THEMES] $1"
}

# Import all necessary functions to work with themes
LIBDIR="$XDG_CONFIG_HOME/themes/lib"

for file in "$LIBDIR"/*.sh; do
  source "$file"
done

case "$1" in
init) init ;;
set_theme) set_theme "$2" ;;
get_theme) get_theme ;;
fetch_themes) fetch_themes ;;
override_property) override_property "$2" "$3" "$4" ;;
generate_configs) generate_configs "${2:-}" ;;
esac
