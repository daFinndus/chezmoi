# Check if waybar is running
QUICKSHELL=$(pgrep quickshell)

if [ -z $QUICKSHELL ]; then
  quickshell -d -c "/home/finn/.config/quickshell/Bars"
else
  quickshell kill -c "/home/finn/.config/quickshell/Bars"
fi
