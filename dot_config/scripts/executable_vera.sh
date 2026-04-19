#!/usr/bin/env bash

# This script shortcuts certain veracrypt commands.
# Can't memorize that.

set -euo pipefail

RED="\033[38;2;220;50;50m"
YELLOW="\033[38;2;220;180;0m"
GREEN="\033[38;2;50;200;50m"
BLUE="\033[38;2;50;120;220m"
RESET="\033[0m"

log_step() { echo -e "\n${BLUE}[*]${RESET} $1"; }
log_success() { echo -e "${GREEN}[+]${RESET} $1"; }
log_warn() { echo -e "${YELLOW}[!]${RESET} $1"; }
log_error() { echo -e "${RED}[-]${RESET} $1"; }

mount() {
  if [[ -n $(ls "$1" 2>/dev/null) ]]; then
    log_success "Detected $1 as the file path!"

    FILE=$1
    PASSWORD=$2
  elif [[ -n $(ls "$2" 2>/dev/null) ]]; then
    log_success "Detected $2 as the file path!"

    FILE=$2
    PASSWORD=$1
  else
    log_error "Couldn't identify the file path. Please use ABSOLUTE file path. Aborting..."
    exit 1
  fi

  log_step "Going to mount provided veracrypt file."

  sudo veracrypt --text --mount "$FILE" /mnt/veracrypt --password "$PASSWORD" --pim 0 --keyfiles "" --protect-hidden no --slot 1

  log_success "Successfully mounted volume."
}

demount() {
  log_step "Going to demount the veracrypt volume."

  sudo veracrypt --text --dismount

  log_success "Demounted volume."
}

main() {
  log_step "Checking if veracrypt volume is already mounted..."

  if [[ -n $(ls "/mnt/veracrypt" 2>/dev/null) ]]; then
    log_success "Yes, it is mounted. Going to demount..."
    demount
  else
    log_success "Doesn't seem to be mounted, going to mount now..."

    if [[ $# -eq 2 ]]; then
      log_success "Provided two params, nice."
      mount $@
    else
      log_error "Please provide the veracrypt file and the password!"
    fi
  fi
}

main $@
