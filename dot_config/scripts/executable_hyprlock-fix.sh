!#/bin/bash

log() {
  echo "[LOCKFIX] $1"
}

exec() {
  sleep 2

  hyprctl --instance 0 $1

  sleep 1
}

log "Going to enable session lock restore..."
log "Returning 'ok's are a good thing."
exec "eval \"hl.config({ misc = { allow_session_lock_restore = true }})\""

log "Now restarting hyprlock!"
exec "eval \"hl.dispatch(hl.dsp.exec_cmd('hyprlock'))\""

log "Now going to enable dpms."
exec "dispatch \"hl.dsp.dpms({ action = 'enable' })\""

