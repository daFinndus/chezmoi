import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons

Rectangle {
    id: root

    required property string command
    required property string inhalt

    width: 60
    height: Globals.barHeight / 1.25

    color: mouseArea.containsMouse ? Colors.background : Colors.color1

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 250
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            System.wlogoutOpen = !System.wlogoutOpen;
            runProcess.start();
        }
    }

    Timer {
        id: runProcess

        interval: Globals.animationDuration
        onTriggered: process.running = true
    }

    Process {
        id: process

        command: ["sh", "-c", root.command]
    }

    function run() {
        process.startDetached();
    }

    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize / 1.25

        color: mouseArea.containsMouse ? Colors.color1 : Colors.color0

        anchors.centerIn: parent

        text: root.inhalt

        Behavior on color {
            ColorAnimation {
                duration: 500
                easing.type: Easing.OutCubic
            }
        }
    }
}
