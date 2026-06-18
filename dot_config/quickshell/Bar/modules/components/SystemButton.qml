import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons

// This component is specifically only for the system buttons
// e.g. shutdown, lock, restart, etc. under the SystemWidget and WlogoutWidget
Rectangle {
    id: button

    required property string command
    required property string inhalt

    property real padding: 16

    width: 96 + padding * 2
    height: Globals.barHeight

    color: mouseArea.containsMouse ? Colors.color2 : Colors.background

    border.color: mouseArea.containsMouse ? Colors.color2 : Colors.color1
    border.width: Globals.borderWidth

    radius: Globals.borderRadius

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
            Globals.wlogoutOpen = !Globals.wlogoutOpen;
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

        command: ["sh", "-c", button.command]
    }

    function run() {
        process.startDetached();

        console.log("Started", button.command);
    }

    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: mouseArea.containsMouse ? Colors.color0 : Colors.color3

        x: parent.padding
        y: parent.padding

        anchors.centerIn: parent

        text: button.inhalt

        Behavior on color {
            ColorAnimation {
                duration: 500
                easing.type: Easing.OutCubic
            }
        }
    }
}
