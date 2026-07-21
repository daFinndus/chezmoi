#!/bin/bash

STATE_FILE="/tmp/kb_variant"
STATE=$(cat "/tmp/kb_variant" 2>/dev/null)

if [[ "$STATE" = "intl" ]]; then
  echo "Variant is currently toggled to 'intl'."
  echo "Removing variant..."

  notify-send "kb_variant" "Changing to default variant."
  
  VALUE=""
else
  echo "Variant seems to be empty."
  echo "Going to add 'intl' for the umlauts..."

  notify-send "kb_variant" "Changing to 'altgr-intl' variant!"

  VALUE="altgr-intl"
fi

hyprctl eval "hl.config({ input = { kb_variant = '$VALUE' }})"
echo "$VALUE" > "$STATE_FILE"
