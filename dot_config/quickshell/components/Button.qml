import QtQuick
import Quickshell.Io

import qs.singletons

Rectangle {
    id: root

    property color background: Colors.background
    property color shade: Colors.color7

    property bool onClickClosePopup: false

    required property string text
    required property string command

    width: text.width * 1.5
    height: text.height + Themes.paddingSize

    // Border color is darker than text color
    border.color: Qt.rgba(root.shade.r, root.shade.g, root.shade.b, 0.25)
    border.width: mouseArea.containsMouse ? 0 : 1

    radius: Themes.borderRadius

    color: mouseArea.containsMouse ? root.shade : root.background

    Text {
        id: text

        font.family: Themes.fontFamily
        font.pixelSize: Themes.iconSize * 0.8

        text: root.text
        color: mouseArea.containsMouse ? Colors.color0 : root.shade

        anchors.centerIn: parent

        Behavior on color {
            ColorAnimation {
                duration: Themes.animationDuration * 2
                easing.type: Easing.OutCubic
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        hoverEnabled: true
        onClicked: {
            command.running = true;

            if (root.onClickClosePopup) {
                Globals.closePopup();
            }
        }
    }

    Process {
        id: command

        running: false

        command: ["sh", "-c", `${root.command}`]
    }
}
