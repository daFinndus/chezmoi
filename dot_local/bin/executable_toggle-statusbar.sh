QUICKSHELL=$(pgrep quickshell)
if [ -z $QUICKSHELL ]; then
  quickshell -d
else
  quickshell kill
fi
