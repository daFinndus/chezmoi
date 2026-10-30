#!/bin/bash

# This script will fetch the temperature and humidity from my sensors

source ~/.config/shell/environment.sh

log() {
  echo "[HOMEASSISTANT] $1"
}

TEMP_URL="http://192.168.178.200/api/states/sensor.apartment_esphome_01_temperature"
HUMI_URL="http://192.168.178.200/api/states/sensor.apartment_esphome_01_humidity"

if [[ -z $HOMEASSISTANT_PASSWORD ]]; then
  log "Missing password, aborting."
  exit 1
fi

TOKEN_HEADER="Authorization: Bearer $HOMEASSISTANT_PASSWORD"
CONTENT_HEADER="Content-Type: application/json"

fetch_state() {
  curl -sS --fail -H "$TOKEN_HEADER" -H "$CONTENT_HEADER" "$1" | jq -r '.state // empty'
}

get_temp() {
  local temp
  temp=$(fetch_state "$TEMP_URL")

  if [[ $temp =~ ^[+-]?[0-9]+([.][0-9]+)?$ ]]; then
    printf "%.1f" "$temp"
  else
    log "TEMP variable is not a number."
  fi
}

get_humi() {
  local humidity
  humidity=$(fetch_state "$HUMI_URL")

  if [[ $humidity =~ ^[+-]?[0-9]+([.][0-9]+)?$ ]]; then
    printf "%.1f" "$humidity"
  else
    log "HUMI variable is not a number."
  fi
}

get_all() {
  local temperature humidity

  temperature=$(fetch_state "$TEMP_URL")
  humidity=$(fetch_state "$HUMI_URL")

  jq -n \
    --arg temperature "$temperature" \
    --arg humidity "$humidity" \
    '{
      temperature: (try ($temperature | tonumber) catch null),
      humidity: (try ($humidity | tonumber) catch null)
    }'
}

case "$1" in
all) get_all ;;
temp) get_temp ;;
humi) get_humi ;;
esac
