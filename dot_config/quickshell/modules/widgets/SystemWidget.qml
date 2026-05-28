import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons

Rectangle {
    property real padding: 16

    width: text.width + padding * 2
    height: Globals.barHeight

    color: Colors.colors.red

    border.color: Colors.colors.red
    border.width: Globals.borderWidth

    radius: 6

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Globals.wlogout = true
    }

    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: Colors.colors.winered

        x: parent.padding
        y: parent.padding

        anchors.centerIn: parent

        text: "System"
    }
}
