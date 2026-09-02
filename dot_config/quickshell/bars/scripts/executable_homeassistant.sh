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

function get_temp() {
  TEMP=$(curl -s -H "$TOKEN_HEADER" -H "$CONTENT_HEADER" $TEMP_URL | jq -r '.state')
  
  if [[ "$TEMP" =~ ^[0-9]+$ ]]; then
    printf "%.1f" "$TEMP"
  else 
    log "TEMP variable is not a number."
  fi
}

function get_humi() {
  HUMI=$(curl -s -H "$TOKEN_HEADER" -H "$CONTENT_HEADER" $HUMI_URL | jq -r '.state')
  
  if [[ "$HUMI" =~ ^[0-9]+$ ]]; then
    printf "%.1f" "$HUMI"
  else
    log "HUMI variable is not a number."
  fi
}

case "$1" in
temp) get_temp ;;
humi) get_humi ;;
esac
