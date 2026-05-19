-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("hypridle")

    hl.exec_cmd("quickshell")
    hl.exec_cmd("dunst")

    -- Get active wallpaper on boot
    hl.exec_cmd(execWallpaper)

    -- Set dark mode and remote button layouts
    hl.exec_cmd(dark)
    hl.exec_cmd(button)
end)
