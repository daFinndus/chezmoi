#!/bin/bash

# This script will toggle my pi-hole blocklists.

RED="\033[38;2;220;50;50m"
YELLOW="\033[38;2;220;180;0m"
GREEN="\033[38;2;50;200;50m"
BLUE="\033[38;2;50;120;220m"
RESET="\033[0m"

log_step() { echo -e "\n${BLUE}[*]${RESET} $1"; }
log_success() { echo -e "${GREEN}[+]${RESET} $1"; }
log_warn() { echo -e "${YELLOW}[!]${RESET} $1"; }
log_error() { echo -e "${RED}[-]${RESET} $1"; }

TIME=""
PASSWORD=""

TOKEN=""

iterate_params() {
  log_step "Going to search for password and time..."

  for arg in "$@"; do
    if [[ $arg =~ ^[0-9]+$ ]]; then
      TIME=$arg
      log_success "Identified time: $TIME seconds."
    else
      PASSWORD=$arg
      log_success "Identified password."
    fi
  done
}

curl_auth_token() {
  log_step "Retrieving SID token..."

  if [[ -z "$PASSWORD" ]]; then
    log_error "Provided no password, aborting!"
    exit 1
  else
    log_success "Got password: $PASSWORD"

    RESPONSE=$(curl -s -k -X POST "http://pi.hole/api/auth" --data "{\"password\":\"$PASSWORD\"}")
    TOKEN=$(echo "$RESPONSE" | jq -r '.session.sid')

    if ! [[ "$TOKEN" == "null" ]]; then
      log_success "Got token: $TOKEN"
    else
      log_error "Couldn't retrieve token, aborting!"
      exit 1
    fi
  fi
}

STATUS=""

check_status() {
  log_step "Checking pi-hole status..."

  RESPONSE=$(curl -s -k -X GET "http://pi.hole/api/dns/blocking?sid=$TOKEN")
  STATUS=$(echo "$RESPONSE" | jq -r '.blocking')

  log_success "Retrieved pi-hole status: $STATUS"

  if [[ "$STATUS" == "enabled" ]]; then
    disable_pihole
  else
    enable_pihole
  fi
}

TIMER="null"

disable_pihole() {
  if [[ -z "$TIME" ]]; then
    log_step "Going to disable pi-hole blocking..."

    RESPONSE=$(curl -s -k -X POST "http://pi.hole/api/dns/blocking" \
      -H "Content-Type: application/json" \
      --data "{\"blocking\": false, \"sid\":\"$TOKEN\"}")
  else
    log_step "Going to disable pi-hole blocking for $TIME seconds..."

    RESPONSE=$(curl -s -k -X POST "http://pi.hole/api/dns/blocking" \
      -H "Content-Type: application/json" \
      --data "{\"blocking\": false, \"timer\": $TIME, \"sid\":\"$TOKEN\"}")

    TIMER=$(echo "$RESPONSE" | jq -r '.timer')
  fi

  STATUS=$(echo "$RESPONSE" | jq -r '.blocking')

  if [[ "$STATUS" == "disabled" ]]; then
    if [[ "$TIMER" == "null" ]]; then
      log_success "Successfully disabled pi-hole blocking."
    else
      log_success "Successfully disabled pi-hole blocking for $TIMER seconds."
    fi
  else
    log_error "Something went wrong, pi-hole blocking is still $STATUS! Aborting..."
    exit 1
  fi
}

enable_pihole() {
  log_step "Going to enable pi-hole blocking..."

  RESPONSE=$(curl -s -k -X POST "http://pi.hole/api/dns/blocking" \
    -H "Content-Type: application/json" \
    --data "{\"blocking\": true, \"sid\":\"$TOKEN\"}")

  STATUS=$(echo "$RESPONSE" | jq -r '.blocking')

  if [[ "$STATUS" == "enabled" ]]; then
    log_success "Successfully enabled pi-hole blocking."
  else
    log_error "Something went wrong, pi-hole blocking is still $STATUS! Aborting..."
    exit 1
  fi
}

delete_sid() {
  log_step "Going to delete the SID now..."

  RESPONSE=$(curl -s -k -X DELETE "http://pi.hole/api/auth?sid=$TOKEN")

  log_success "SID is now invalid."
}

iterate_params "$@"
curl_auth_token
check_status
delete_sid
