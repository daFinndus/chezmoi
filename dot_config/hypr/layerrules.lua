-- For the quattro quickshell taskbar
hl.layer_rule({
    name = "quattro-taskbar-blur",
    match = { namespace = "quattro-taskbar" },
    blur = true,
})

-- For notifications
hl.layer_rule({
    name = "dunst-transparency",
    match = { namespace = "notifications" },
    ignore_alpha = 1,
    blur = true,
})
