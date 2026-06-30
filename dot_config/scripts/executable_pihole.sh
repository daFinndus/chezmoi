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

prompt_password() {
  log_step "Please enter your password."
  read -s -r -p "[:] > " PASSWORD
  echo

  if [[ -z "$PASSWORD" ]]; then
    log_error "Please enter a valid password."
    exit 1
  fi

  log_step "Please confirm your password."
  read -s -r -p "[:] > " CONFIRM
  echo

  if [[ "$PASSWORD" != "$CONFIRM" ]]; then
    log_error "Passwords do not match!"
    exit 1
  fi
}

get_time() {
  if [[ -n "$1" ]]; then
    log_step "Time was provided!"
    log_success "Using $1 in seconds as time."

    TIME="$1"
  fi
}

curl_auth_token() {
  log_step "Retrieving SID token..."

  if [[ -z "$PASSWORD" ]]; then
    log_error "Provided no password, aborting!"
    exit 1
  else
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
      log_warn "Successfully disabled pi-hole blocking."
    else
      log_warn "Successfully disabled pi-hole blocking for $TIMER seconds."
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
    log_warn "Successfully enabled pi-hole blocking."
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

if [[ -z "$PIHOLE_PASSWORD" ]]; then
  prompt_password
else
  PASSWORD="$PIHOLE_PASSWORD"
fi

get_time
curl_auth_token
check_status
delete_sid
