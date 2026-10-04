-- For the quattro quickshell taskbar
hl.layer_rule({
    name = "quattro-taskbar-blur",
    match = { namespace = "quattro-taskbar" },
    blur = true,
    blur_popups = true,
    ignore_alpha = 0,
})

-- For the quickshell wallpaper and themes selector menu
hl.layer_rule({
    name = "quickshell-selector-blur",
    match = { namespace = "quickshell-selector" },
    blur = true,
    blur_popups = true,
    ignore_alpha = 0,
})

-- For notifications
hl.layer_rule({
    name = "dunst-transparency",
    match = { namespace = "notifications" },
    blur = true,
    blur_popups = true,
    ignore_alpha = 0,
})

-- App menu
hl.layer_rule({
    name = "rofi-transparency",
    match = { namespace = "rofi" },
    blur = true,
    ignore_alpha = 0,
})
