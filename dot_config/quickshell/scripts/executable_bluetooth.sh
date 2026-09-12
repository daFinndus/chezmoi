#!/bin/bash

# This will fetch devices after scanning from bluetoothctl
# It's doing that so weirdly and complicated to keep the interactive session alive
scan_devices() {
    {
        echo "scan on"
        sleep 5
        echo "devices"
        echo "scan off"
    } |
        bluetoothctl |
        awk '/^Device/ {print $2}'
}

get_device_info() {
    local address=$1
    local info=$(bluetoothctl info "$address")

    local name=$(echo "$info" | awk -F': ' '/^\s+Name:/      {print $2}')

    local paired=$(echo "$info" | awk '/Paired:/    {print ($2=="yes") ? "true" : "false"}')
    local trusted=$(echo "$info" | awk '/Trusted:/   {print ($2=="yes") ? "true" : "false"}')
    local connected=$(echo "$info" | awk '/Connected:/ {print ($2=="yes") ? "true" : "false"}')

    [[ -z "$name" || "$name" =~ ^[0-9A-F]{2}(-[0-9A-F]{2}){5}$ ]] && return 1

    echo "{\"address\":\"$address\",\"name\":\"$name\",\"paired\":${paired:-false},\"trusted\":${trusted:-false},\"connected\":${connected:-false}}"
}

# Get all available devices
# Fetch relevant information via `bluetoothctl info`
fetch_devices() {
    scan_devices | while read -r address; do
        echo $(get_device_info "$address")
    done | jq -s '.'
}

fetch_devices
