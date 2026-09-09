import QtQuick
import Quickshell.Io

import qs.singletons

Rectangle {
    id: root

    property color background: Themes.background
    property color shade: Themes.shade

    property int iconSize: Themes.iconSize * 0.8

    property bool onClickClosePopup: false

    required property string text
    property string command: ""

    width: text.width + Themes.paddingSize * 2
    height: text.height + Themes.paddingSize

    // Border color is darker than text color
    border.color: Qt.rgba(root.shade.r, root.shade.g, root.shade.b, 0.25)
    border.width: mouseArea.containsMouse ? 0 : 1

    radius: Themes.borderRadius

    color: mouseArea.containsMouse ? root.shade : root.background

    Text {
        id: text

        font.family: Themes.fontFamily
        font.pixelSize: root.iconSize

        text: root.text
        color: mouseArea.containsMouse ? root.background : root.shade

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
            // Either wait for a closing popup
            // Or execute the function directly
            if (root.onClickClosePopup) {
                Globals.closePopup();
                debounceCommand.start();
            } else {
                command.running = true;
            }
        }
    }

    // Wait until the popup disappears
    // Then execute the function
    // This is so animations are done before function execution
    Timer {
        id: debounceCommand

        running: false
        interval: Themes.animationDuration

        onTriggered: command.running = true
    }

    Process {
        id: command

        running: false

        command: ["sh", "-c", `${root.command}`]
    }
}
