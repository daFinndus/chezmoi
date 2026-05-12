CONNECTED=$(sudo wg show)

log() {
	echo "[WIREGUARD] $1"
}

if [[ -z "$CONNECTED" ]]; then
	log "Seems you are not connected to home network..."
	sudo wg-quick up kabuki

	if [[ $(echo $? -eq 0) ]]; then
		notify-send "Wireguard" "Now connected to home network"
		log "Now connected to home VPN."
	else
		notify-send "Wireguard" "Something went wrong!"
		log "Couldn't connect to home network."
	fi
else
	log "Seems wireguard is already up and running!"
	sudo wg-quick down kabuki

	if [[ $(echo $? -eq 0) ]]; then
		notify-send "Wireguard" "Disconnected from home network"
		log "Closed connection now."
	else
		notify-send "Wireguard" "Something went wrong!"
		log "Couldn't disconnect from home network."
	fi
fi
