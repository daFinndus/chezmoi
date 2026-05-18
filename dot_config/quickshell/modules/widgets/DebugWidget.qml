import QtQuick
import Quickshell

import qs.singletons

Rectangle {
    property real padding: 8

    width: 74 + padding * 2
    height: Globals.barHeight

    color: Colors.colors.background

    border.color: Colors.colors.lightgray
    border.width: Globals.borderWidth

    radius: 6

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

    Text {
        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: Colors.colors.white

        x: parent.padding
        y: parent.padding

        anchors.centerIn: parent

        text: "Debug"
    }

}
