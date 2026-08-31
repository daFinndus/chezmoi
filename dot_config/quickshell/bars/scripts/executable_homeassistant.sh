#!/bin/bash

source ~/.config/shell/environment.sh

log() {
    echo "[HOMEASSISTANT] $1"
}

TEMP_URL="http://192.168.178.23/api/states/sensor.apartment_esphome_01_temperature"
HUMI_URL="http://192.168.178.23/api/states/sensor.apartment_esphome_01_humidity"

if [[ -z "$HOMEASSISTANT_PASSWORD" ]]; then
    log "Missing password, aborting."
    exit 1
fi

TOKEN_HEADER="Authorization: Bearer $HOMEASSISTANT_PASSWORD"
CONTENT_HEADER="Content-Type: application/json"

TEMP=$(curl -s -H "$TOKEN_HEADER" -H "$CONTENT_HEADER" $TEMP_URL | jq -r '.state')
HUMI=$(curl -s -H "$TOKEN_HEADER" -H "$CONTENT_HEADER" $HUMI_URL | jq -r '.state')

case "$1" in
temp) printf "%.1f" "$TEMP" ;;
humi) printf "%.1f" "$HUMI" ;;
esac
