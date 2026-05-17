import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.singletons

Rectangle {
    property int padding: 8

    property bool inhibited: Wayland.IdleInhibitor.enabled

    width: 172
    height: Globals.barHeight

    color: Globals.backgroundColor

    border.color: Globals.borderColor
    border.width: Globals.borderWidth

    radius: 6

    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: Globals.inhibited ? Globals.colors.green : Globals.colors.red

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