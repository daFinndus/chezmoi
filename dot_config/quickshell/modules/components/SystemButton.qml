import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons

Rectangle {
    id: button

    required property string command
    required property string inhalt

    property real padding: 16

    width: 96 + padding * 2
    height: Globals.barHeight

    color: mouseArea.containsMouse ? Colors.colors.winered : Colors.colors.background

    border.color: mouseArea.containsMouse ? Colors.colors.red : Colors.colors.gray
    border.width: Globals.borderWidth

    radius: 6

    Behavior on color {
        ColorAnimation {
            duration: 250
        }
    }

    opacity: Globals.wlogoutClickable ? 1 : 0

    Behavior on opacity {
        NumberAnimation {
            duration: Globals.wlogoutFadeDelay
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Globals.wlogoutClickable ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: {
            if (Globals.wlogoutClickable) {
                run();
            }
        }

        onEntered: {
            Globals.wlogoutHovered = true;

            console.log("Globals are:");
            console.log("wlogoutOpen:", Globals.wlogoutOpen);
            console.log("wlogoutHovered:", Globals.wlogoutHovered);
            console.log("wlogoutClickable:", Globals.wlogoutClickable);
        }
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

        color: mouseArea.containsMouse ? Colors.colors.red : Colors.colors.white

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
