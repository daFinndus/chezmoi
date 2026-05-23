import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.singletons

Rectangle {
    property int padding: 16

    width: text.width + padding * 2
    height: Globals.barHeight

    color: Colors.colors.background

    border.color: Colors.colors.gray
    border.width: Globals.borderWidth

    radius: 6

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: Globals.inhibited ? Colors.colors.green : Colors.colors.red

        x: parent.padding
        y: parent.padding

        anchors.centerIn: parent

        text: Globals.inhibited ? "Inhibitor: Active" : "Inhibitor: Inactive"

        Behavior on color {
            ColorAnimation {
                duration: 500
                easing.type: Easing.OutCubic
            }
        }
    }

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