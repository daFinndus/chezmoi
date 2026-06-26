import QtQuick
import Quickshell.Io

import qs.singletons

Rectangle {
    id: root

    required property string farbe
    required property string inhalt

    property real padding: 12

    width: text.width + padding * 3
    height: Globals.barHeight

    color: Colors.background

    border.color: farbe
    border.width: Globals.borderWidth

    radius: Globals.borderRadius

    Behavior on width {
        NumberAnimation {
            duration: Globals.animationDuration / 2
        }
    }

    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: root.farbe

        x: parent.padding
        y: parent.padding

        anchors.centerIn: parent

        text: root.inhalt

        Behavior on color {
            ColorAnimation {
                duration: 500
                easing.type: Easing.OutCubic
            }
        }
    }
}
