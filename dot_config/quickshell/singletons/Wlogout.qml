pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var wlogoutSelected: root.systemFunctions[root.wlogoutIndex]
    property int wlogoutIndex: 0

    function startSystemFunction(command: string): void {
        runCommand.command = ["sh", "-c", `${command}`];
        runCommand.running = true;
    }

    Process {
        id: runCommand
    }

    function getText(index: int): string {
        if (Themes.iconMode) {
            return "\uf08b";
        } else {
            return root.systemFunctions[index].text;
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
