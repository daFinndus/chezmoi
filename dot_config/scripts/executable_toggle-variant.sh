#!/bin/bash

VARIANT=$(hyprctl getoption input:kb_variant | grep intl | awk '{print $2}')

if [[ -Z "$VARIANT" ]]; then
  echo "Variant is currently toggled to 'intl'."
  echo "Removing variant..."

  hyprctl eval "hl.config({ input = { kb_variant = '' }})"
else
  echo "Variant seems to be empty."
  echo "Going to add 'intl' for the umlauts..."

  hyprctl eval "hl.config({ input = { kb_variant = 'intl' }})"
fi
