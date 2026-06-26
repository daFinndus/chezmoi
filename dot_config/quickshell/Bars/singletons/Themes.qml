pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons

Singleton {
    id: root

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        acceptedButtons: Qt.LeftButton

        onClicked: switchTheme()
    }

    Process {
        id: reloadHypr

        command: ["hyprctl", "reload"]
    }

    Process {
        id: applyHypr

        command: ["hyprctl", "eval", "hl.workspace_rule({ workspace = '', no_rounding = true, decorate = false, no_border = true, gaps_in = 0, gaps_out = 0})"]
    }

    function reloadHypr() {
        reloadHypr.running = true;
    }

    function switchTheme() {
        Globals.statusbarVisible = !Globals.statusbarVisible;

        if (!Globals.statusbarVisible) {
            root.reloadHypr();
        } else {
            applyHypr.running = true;
        }
    }

    Process {
        id: ipc

        running: true

        command: [`${Globals.configPath}/scripts/ipc.sh`]

        stdout: SplitParser {
            onRead: data => {
                console.log("Retrieved data: ", data);

                const cmd = data.trim();

                if (cmd === "bar") {
                    root.switchTheme();
                }
            }
        }

        // This shouldn't exit because of read -p
        onExited: ipc.running = true
    }
}
