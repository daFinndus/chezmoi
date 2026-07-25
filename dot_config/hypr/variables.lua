-- Variables
-- Set commonly used apps
terminal = "kitty"
cleanTerminal = "kitty --config ~/.config/kitty/clean.conf bash"

filemanager = "kitty --class kitty --title yazi -e yazi"
menu = "rofi -show drun -show-icons"
browser = "helium-browser"

screenshot = 'hyprshot -m region -o "$HOME/Downloads"'

toggleStatusbar = "/home/finn/.config/scripts/toggle-statusbar.sh"
toggleKeyboard = "/home/finn/.config/scripts/toggle-keyboard.sh"
execWallpaper = "/home/finn/.config/scripts/wallpaper.sh"

dark = 'gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"'
button = "gsettings set org.gnome.desktop.wm.preferences button-layout ':'"

-- Set main modifier key
mainMod = "SUPER"
