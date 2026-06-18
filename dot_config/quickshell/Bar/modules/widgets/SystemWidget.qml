import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons

Rectangle {
    // This is set based on the dropdown menu
    width: 126
    height: Globals.barHeight

    color: Colors.color1

    border.color: Colors.color1
    border.width: Globals.borderWidth

    radius: Globals.borderRadius

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Globals.wlogoutOpen = !Globals.wlogoutOpen
    }

    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: Colors.color0

        anchors.centerIn: parent

        text: Globals.wlogoutOpen ? "Abort" : "System"
    }
}
