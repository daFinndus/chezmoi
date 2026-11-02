#!/bin/bash

fetch_vpn() {
  local -a connections=()

  profiles=$(nmcli --get-values NAME,TYPE,STATE connection show)

  echo "$profiles" | while read -r vpn; do
    if [[ -n "$vpn" ]]; then
      name=$(echo "$vpn" | cut -d ":" -f 1)
      type=$(echo "$vpn" | cut -d ":" -f 2)
      active=$(echo "$vpn" | cut -d ":" -f 3)

      # Filter for VPNs
      case "$type" in
      vpn | wireguard | tailscale) add_profile "$name" "$type" "$active" ;;
      *) continue ;;
      esac
    fi
  done | jq -s '.'
}

add_profile() {
  name="$1"
  type="$2"
  [[ -n $(echo "$3") ]] && active=true || active=false

  jq -n \
    --arg name "$name" \
    --arg type "$type" \
    --argjson active "$active" \
    '{
        name: $name,
        type: $type,
        active: $active
    }'
}

toggle_vpn() {
  name="$1"

  if [[ -n $(nmcli --get-values ACTIVE connection show $name) ]]; then
    nmcli connection down $name
  else
    nmcli connection up $name
  fi
}

case "$1" in
fetch) fetch_vpn ;;
toggle) toggle_vpn "$2" ;;
esac
