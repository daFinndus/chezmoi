pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool wlogoutOpen: false
    property bool wlogoutVisible: false

    default property list<var> systemFunctions: [
        {
            command: "systemctl poweroff",
            inhalt: "Shutdown"
        },
        {
            command: "systemctl reboot",
            inhalt: "Reboot"
        },
        {
            command: "systemctl reboot --firmware",
            inhalt: "Firmware"
        },
        {
            command: "systemctl suspend",
            inhalt: "Suspend"
        },
        {
            command: "hyprctl dispatch 'hl.dsp.exit()'",
            inhalt: "Logout"
        },
        {
            command: "hyprlock",
            inhalt: "Lock"
        }
    ]
}
