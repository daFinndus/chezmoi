# Save old package amount
count=$(checkupdates | wc -l)

# Proceed doing the update itself
kitty --class kitty --title updater -e yay -Syu

# Save new package amount
current=$(checkupdates | wc -l)

if [[ "$current" -eq 0 ]]; then
  notify-send "Updater" "All packages are updated"
elif [[ "$current" -lt "$count" ]]; then
  notify-send "Updater" "Seems some packages were updated"
else
  notify-send "Updater" "Something went wrong"
fi
