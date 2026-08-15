pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool wlogoutVisible: false

    property var wlogoutSelected: root.systemFunctions[root.wlogoutIndex]
    property int wlogoutIndex: 0

    function startSystemFunction() {
        runCommand.command = ["sh", "-c", `${root.wlogoutSelected.command}`];
        runCommand.running = true;
    }

    Process {
        id: runCommand
    }

    function getText(containsMouse = false) {
        if (containsMouse) {
            return root.systemFunctions[root.wlogoutIndex].inhalt;
        } else {
            return "System";
        }
    }

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
