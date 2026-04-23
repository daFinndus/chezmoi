#!/bin/bash

# This script is used to run specific duplicati backups.

RED="\033[38;2;220;50;50m"
YELLOW="\033[38;2;220;180;0m"
GREEN="\033[38;2;50;200;50m"
BLUE="\033[38;2;50;120;220m"
RESET="\033[0m"

log_step() { echo -e "\n${BLUE}[*]${RESET} $1"; }
log_success() { echo -e "${GREEN}[+]${RESET} $1"; }
log_warn() { echo -e "${YELLOW}[!]${RESET} $1"; }
log_error() { echo -e "${RED}[-]${RESET} $1"; }

PASSWORD=$1
TOKEN=""

test_target_reachability() {
  log_step "Going to test reachability of necessary machines."

  WORKSTATION=$(ping 192.168.0.80 -w 3 | grep "time")
  DUPLICATI=$(ping 192.168.0.64 -w 3 | grep "time")

  if [[ -n "$DUPLICATI" ]]; then
    log_success "Duplicati seems reachable."
  else
    log_error "Duplicati seems not reachable, aborting..."
    exit 1
  fi
}

# This is to curl the auth token.
curl_auth_token() {
  log_step "Going to curl access token..."

  if [[ -z "$PASSWORD" ]]; then
    log_error "Provided no password, aborting!"
    exit 1
  else
    log_success "Got password: $PASSWORD"

    RESPONSE=$(curl -s -X POST http://192.168.0.64:8200/api/v1/auth/login \
      -H "Content-Type: application/json" \
      -d "{\"Password\": \"$PASSWORD\"}")

    TOKEN=$(echo "$RESPONSE" | jq -r '.AccessToken')

    if [[ "$TOKEN" != "null" ]]; then
      log_success "Got token!"
    else
      log_error "Couldn't retrieve token."
      exit 1
    fi
  fi
}

IDS=()
NAMES=()

# This is to retrieve current backups ids
get_backup_ids() {
  log_step "Going to retrieve backups."

  RESPONSE=$(curl -s http://192.168.0.64:8200/api/v1/backups \
    -H "Authorization: Bearer $TOKEN")

  IDS=$(echo "$RESPONSE" | jq -r '.[].Backup.ID')
  NAMES=$(echo "$RESPONSE" | jq -r '.[].Backup.Name')

  mapfile -t IDS <<<"$IDS"
  mapfile -t NAMES <<<"$NAMES"

  if [[ "${#IDS[@]}" -gt 0 ]]; then
    log_success "Found the following backup id's:\n"

    for ((i = 0; i < ${#IDS[@]}; i++)); do
      echo "${IDS[i]} : ${NAMES[i]}"
    done
  else
    log_warn "Didn't find any backups... aborting."
    exit 0
  fi
}

# This will make sure my HDD is mounted, necessary for one backup.
mount_hdd() {
  if [[ "$HOSTNAME" == "krabby" ]]; then
    log_step "Going to make sure HDD is mounted."

    MOUNTED=$(df -h | grep "/mnt/hdd")

    if [[ -n "$MOUNTED" ]]; then
      log_success "Found HDD in mounted drives, nice!"
    else
      log_warn "HDD is not mounted, going to mount it now."

      sudo mount /dev/sda2 /mnt/hdd -t ntfs
    fi
  fi
}

# This function will backup everything.
# Maybe update this to do specific backups later.
do_backups() {
  log_step "Going to do backups..."

  for ((i = 0; i < ${#IDS[@]}; i++)); do
    if [[ "${NAMES[i]}" != *"Local"* && "$HOSTNAME" != "krabby" ]]; then
      log_warn "Skipping backup ${NAMES[i]} since it is not a local backup and we are not on krabby.\n"
      continue
    fi

    echo ""

    log_success "Going to run update for backup: ${NAMES[i]}"

    RESPONSE=$(curl -s -X POST http://192.168.0.64:8200/api/v1/backup/${IDS[i]}/run \
      -H "Authorization: Bearer $TOKEN")

    if [[ "$RESPONSE" == *"OK"* ]]; then
      log_success "Authorized backup for ${NAMES[i]}."
    else
      log_error "Backup progress failed for ${NAMES[i]}."
    fi

    echo ""
    sleep 3
  done

  log_success "Successfully did all backups!"
}

test_target_reachability
curl_auth_token
get_backup_ids
mount_hdd
do_backups
