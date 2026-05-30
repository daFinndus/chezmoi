-- Windowrules

-- Fix dragging issues with XWayland
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.window_rule({
	name = "float-alsamixer",
	match = { class = terminal, title = "alsamixer" },
	size = { 1200, 800 },
	center = true,
	float = true,
})

hl.window_rule({
	name = "float-iwctl",
	match = { title = "iwctl" },
	size = { 1200, 800 },
	center = true,
	float = true,
})

hl.window_rule({
	name = "float-bluetoothctl",
	match = { class = terminal, title = "bluetoothctl" },
	size = { 1200, 800 },
	center = true,
	float = true,
})

hl.window_rule({
	name = "float-updater",
	match = { title = "updater" },
	size = { 1200, 800 },
	center = true,
	float = true,
})

hl.window_rule({
	name = "float-pavucontrol",
	match = { class = "org.pulseaudio.pavucontrol" },
	size = { 1200, 800 },
	center = true,
	float = true,
})

hl.window_rule({
	name = "float-discord",
	match = { class = "discord" },
	size = { 1200, 800 },
	center = true,
	float = true,
})

hl.window_rule({
	name = "float-bitwarden",
	match = { class = "Bitwarden", title = "Bitwarden" },
	size = { 1200, 800 },
	center = true,
	float = true,
})

hl.window_rule({
	name = "float-virt-manager",
	match = { class = "virt-manager" },
	size = { 1200, 800 },
	center = true,
	float = true,
})

hl.window_rule({
	name = "float-spotify",
	match = { class = "Spotify" },
	size = { 1200, 800 },
	float = true,
})

hl.window_rule({
	name = "float-yazi",
	match = { class = terminal, title = "yazi" },
	size = { 1200, 800 },
	float = true,
})

hl.window_rule({
	name = "float-obs",
	match = { class = "com.obsproject.Studio" },
	size = { 1200, 800 },
	center = true,
	float = true,
})

hl.window_rule({
	name = "gnome-everything",
	match = { class = ".*" },
	animation = "gnome",
})
