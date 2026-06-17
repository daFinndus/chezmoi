-- Autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("hypridle")

	hl.exec_cmd("dunst")

	-- Get active wallpaper on boot
	hl.exec_cmd(execWallpaper)

	-- Set dark mode and remote button layouts
	hl.exec_cmd(dark)
	hl.exec_cmd(button)

	-- This is so quickshell is always started on the main monitor
	hl.exec_cmd("hyprctl dispatch 'hl.dsp.focus({ workspace = '1' })'")
	hl.exec_cmd("quickshell -d -c ~/.config/quickshell/Bar")
end)
