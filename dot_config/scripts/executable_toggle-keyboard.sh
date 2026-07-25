#!/bin/bash

KEYBOARD_FILE="/tmp/keyboard"

LAYOUT=$(head -1 "$KEYBOARD_FILE" 2>/dev/null)
VARIANT=$(tail -1 "$KEYBOARD_FILE" 2>/dev/null)

log() {
  echo "[kb_settings] $1"
}

log "LAYOUT before: $(hyprctl getoption input.kb_layout)"
log "VARiANT before: $(hyprctl getoption input.kb_variant)"

if [[ "$LAYOUT" = "us" ]] && [[ "$VARIANT" = "altgr-intl" ]]; then
  log "Variant is currently toggled to 'intl'."
  log "Removing variant and changing back to 'de' layout..."

  notify-send "kb_settings" "Changing to default settings."
  
  LAYOUT="de"
  VARIANT=""
elif [[ "$LAYOUT" = "de" ]]; then
  log "Variant and language seem to be default."
  log "Changing to 'us' layout with no variant".

  notify-send "kb_settings" "Changing to 'us' layout."

  LAYOUT="us"
  VARIANT=""
elif [[ "$LAYOUT" = "us" ]] && [[ "$VARIANT" = "" ]]; then
  log "Variant seems to be empty."
  log "Going to add 'altgr-intl' for the umlauts..."

  notify-send "kb_settings" "Changing to 'altgr-intl' variant!"

  LAYOUT="us"
  VARIANT="altgr-intl"
fi

hyprctl eval "hl.config({ input = { kb_layout = '$LAYOUT', kb_variant = '$VARIANT' }})"

log "LAYOUT now: $(hyprctl getoption input.kb_layout)"
log "VARIANT now: $(hyprctl getoption input.kb_variant)"

echo "$LAYOUT" > "$KEYBOARD_FILE"
echo "$VARIANT" >> "$KEYBOARD_FILE"
