#!/usr/bin/env bash

log() {
  echo "[LOCKFIX] $1"
}

execute() {
  sleep 2

  hyprctl --instance 0 "$1" "$2"

  sleep 1
}

log "Going to enable session lock restore..."
log "Returning 'ok's are a good thing."
execute eval "hl.config({ misc = { allow_session_lock_restore = true }})"

log "Now restarting hyprlock!"
execute eval "hl.dispatch(hl.dsp.exec_cmd('hyprlock'))"

log "Now going to enable dpms."
execute dispatch "hl.dsp.dpms({ action = 'enable' })"

