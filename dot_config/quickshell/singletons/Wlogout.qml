pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool widgetHovered: false
    property bool wlogoutVisible: false

    property var wlogoutSelected: root.systemFunctions[root.wlogoutIndex]
    property int wlogoutIndex: 0

    function startSystemFunction(): void {
        runCommand.command = ["sh", "-c", `${root.wlogoutSelected.command}`];
        runCommand.running = true;
    }

    Process {
        id: runCommand
    }

    function getText(containsMouse = false): string {
        if (Themes.iconMode) {
            return "\uf08b";
        } else {
            if (containsMouse) {
                return root.systemFunctions[root.wlogoutIndex].text;
            } else {
                return "System";
            }
        }
    }

    default property list<var> systemFunctions: [
        {
            command: "systemctl poweroff",
            text: "Shutdown",
            icon: "\f0425"
        },
        {
            command: "systemctl reboot",
            text: "Reboot"
        },
        {
            command: "systemctl reboot --firmware",
            text: "Firmware"
        },
        {
            command: "systemctl suspend",
            text: "Suspend"
        },
        {
            command: "hyprctl dispatch 'hl.dsp.exit()'",
            text: "Logout"
        },
        {
            command: "hyprlock",
            text: "Lock"
        }
    ]
}
