import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons

Rectangle {
    id: root

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

        onClicked: System.wlogoutOpen = !System.wlogoutOpen
    }

    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: Colors.color0

        anchors.centerIn: parent

        text: System.wlogoutOpen ? "Abort" : "System"
    }
}
