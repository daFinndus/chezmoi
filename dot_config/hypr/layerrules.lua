-- For the quattro quickshell taskbar
hl.layer_rule({
    name = "quattro-taskbar-blur",
    match = { namespace = "quattro-taskbar" },
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
