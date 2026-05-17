import QtQuick
import Quickshell

import qs.singletons

Rectangle {
    property real padding: 8

    width: 74 + padding * 2
    height: Globals.barHeight

    color: Globals.backgroundColor

    border.color: Globals.borderColor
    border.width: Globals.borderWidth

    radius: 6

    Text {
        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: Globals.foregroundColor

        x: parent.padding
        y: parent.padding

        anchors.centerIn: parent

        text: "Tray"
    }

}
