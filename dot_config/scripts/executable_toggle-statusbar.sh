# Check if waybar is running
QUICKSHELL=$(pgrep quickshell)

if [ -z $QUICKSHELL ]; then
  quickshell -d -c "/home/finn/.config/quickshell/Bar"
else
  quickshell kill
fi
