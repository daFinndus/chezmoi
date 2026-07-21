-- Hyprland configuration file

-- Variables need to be first
require("variables")

-- Colors
require("colors")

-- Rest of 'em
require("autostart")
require("binds")
require("input")
require("monitors")
require("windowrules")
require("workspacerules")

-- Environment variables
hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "bibata-modern")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- Look and feel
hl.config({
	general = {
		gaps_in = 1,
		gaps_out = 2,

		border_size = 1,

		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",

		col = {
			active_border = { colors = { color4, color14 }, angle = 45 },
			inactive_border = { colors = { color2, color3 }, angle = 45 },
		},
	},
	decoration = {
		-- Window roundings
		rounding = 4,
		rounding_power = 2,

		-- Window transparency
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		-- Shadow settings
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		-- Blur settings
		blur = {
			enabled = true,
			size = 8,
			passes = 2,
			vibrancy = 0.1696,
		},
	},
	dwindle = {
		preserve_split = true,
	},
	master = {
		new_status = "master",
	},
	scrolling = {
		fullscreen_on_one_column = true,
	},
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},
	animations = {
		enabled = true,
	},
	cursor = {
		no_hardware_cursors = true,
	},
})

-- This is all stolen from ML4W
-- Animation Curves (Bezier)
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("md3_standard", { type = "bezier", points = { {0.2, 0}, {0, 1} } })
hl.curve("md3_decel", { type = "bezier", points = { {0.05, 0.7}, {0.1, 1} } })
hl.curve("md3_accel", { type = "bezier", points = { {0.3, 0}, {0.8, 0.15} } })
hl.curve("overshot", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.1} } })
hl.curve("crazyshot", { type = "bezier", points = { {0.1, 1.5}, {0.76, 0.92} } })
hl.curve("hyprnostretch", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.0} } })
hl.curve("fluent_decel", { type = "bezier", points = { {0.1, 1}, {0, 1} } })
hl.curve("easeInOutCirc", { type = "bezier", points = { {0.85, 0}, {0.15, 1} } })
hl.curve("easeOutCirc", { type = "bezier", points = { {0, 0.55}, {0.45, 1} } })
hl.curve("easeOutExpo", { type = "bezier", points = { {0.16, 1}, {0.3, 1} } })

-- Animation Rules
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "md3_decel", style = "popin 60%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.5, bezier = "md3_decel" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.5, bezier = "easeOutExpo", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "md3_decel", style = "slidevert" })
