import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.singletons
import qs.modules.components

Rect {
    farbe: Globals.inhibited ? Colors.colors.green : Colors.colors.red
    inhalt: Globals.inhibited ? "Inhibitor: Active" : "Inhibitor: Inactive"

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (Globals.inhibited) {
                Globals.inhibited = false

            } else {
                Globals.inhibited = true
            }
        }
    }

    Process {
        id: inhibitProcess

        readonly property string who: "--who=quickshell"
        readonly property string what: "--what=idle"
        readonly property string why: "--why=Quickshell inhibitor"

        command: {
            if (!Globals.inhibited) return ["true"]

            console.log("Inhibitor: Starting inhibitor process...")
            
            return ["systemd-inhibit", what, who, why, "sleep", "infinity"]
        }

        running: Globals.inhibited

        onExited: function (exitCode) {
            if (Globals.inhibited && exitCode !== 0) {
                console.warn("Inhibitor: Inhibitor process crashed with exit code:", exitCode)

                Globals.inhibited = false
            }
        }
    }
}