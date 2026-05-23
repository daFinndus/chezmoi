import QtQuick
import Quickshell

import qs.singletons

Rectangle {
    property real padding: 16

    width: text.width + padding * 2
    height: Globals.barHeight

    color: Colors.colors.background

    border.color: Colors.colors.gray
    border.width: Globals.borderWidth

    radius: 6

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: Colors.colors.white

        x: parent.padding
        y: parent.padding

        anchors.centerIn: parent

        text: Time.shortTime
    }

}
