#!/bin/bash

DEVICE=$1
ACTION=$2

case "$ACTION" in
connect)
    output=$(bluetoothctl connect "$DEVICE" 2>&1)

    if echo "$output" | grep -q "Connection successful"; then
        notify-send "Bluetooth" "Connected to $DEVICE"
    else
        error=$(echo "$output" | grep "Failed" | head -1)
        notify-send "Bluetooth" "Failed: ${error:-Unknown error}"
    fi

    echo "Output was: $output"
    ;;
disconnect)

    output=$(bluetoothctl disconnect "$DEVICE" 2>&1)
    if echo "$output" | grep -q "Disconnection successful"; then
        notify-send "Bluetooth" "Disconnected from $DEVICE"
    else
        notify-send "Bluetooth" "Failed to disconnect"
    fi

    echo "Output was: $output"
    ;;
esac
