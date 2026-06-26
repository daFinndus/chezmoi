import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.singletons
import qs.modules.components

Rectangle {
    id: root

    width: text.implicitWidth
    height: statusbar.height

    color: Colors.background

    Behavior on width {
        NumberAnimation {
            duration: Globals.animationDuration / 2
        }
    }

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (Globals.inhibited) {
                Globals.inhibited = false;
            } else {
                Globals.inhibited = true;
            }
        }
    }

    Process {
        id: inhibitProcess

        readonly property string who: "--who=quickshell"
        readonly property string what: "--what=idle"
        readonly property string why: "--why=Quickshell inhibitor"

        command: {
            if (!Globals.inhibited)
                return ["true"];

            console.log("Inhibitor: Starting inhibitor process...");

            return ["systemd-inhibit", what, who, why, "sleep", "infinity"];
        }

        running: Globals.inhibited

        onExited: function (exitCode) {
            if (Globals.inhibited && exitCode !== 0) {
                console.warn("Inhibitor: Inhibitor process crashed with exit code:", exitCode);

                Globals.inhibited = false;
            }
        }
    }

    Text {
        id: text

        font.pixelSize: Globals.fontSize / 1.25

        text: Globals.inhibited ? "Inhibitor: Active" : "Inhibitor: Inactive"

        leftPadding: 4
        rightPadding: 4

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        color: Globals.inhibited ? Colors.color6 : Colors.color1
    }
}
