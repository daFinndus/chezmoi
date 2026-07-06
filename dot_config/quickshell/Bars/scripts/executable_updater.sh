#!/bin/bash

# Save old package amount
count=$(checkupdates | wc -l)

# Proceed doing the update itself
kitty -o window_margin_width=8 --title updater -e zsh -c '
if ! yay -Syu; then
    echo
    echo "Update failed."
	echo "Please check the output above for more details."
    read -n 1 -s -r -p "Press any key to continue..."
fi
'

# Save new package amount
current=$(checkupdates | wc -l)

if [[ "$current" -eq 0 ]]; then
    notify-send "Updater" "All packages are updated"
    exit 0
elif [[ "$current" -lt "$count" ]]; then
    notify-send "Updater" "Seems some packages were updated"
    exit 1
else
    notify-send "Updater" "Something went wrong"
    exit 1
fi
