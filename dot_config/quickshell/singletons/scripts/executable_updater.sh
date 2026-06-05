#!/usr/bin/env bash

# Save old package amount
count=$(checkupdates | wc -l)

# Proceed doing the update itself
kitty --title updater -e bash -c '
echo "Updating mirrors..."
sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

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
elif [[ "$current" -lt "$count" ]]; then
  notify-send "Updater" "Seems some packages were updated"
else
  notify-send "Updater" "Something went wrong"
fi
