import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons

Rectangle {
    id: button

    required property string farbe
    required property string inhalt

    property real padding: 16

    width: 96 + padding * 2
    height: Globals.barHeight

    color: mouseArea.containsMouse ? farbe : Colors.background

    border.color: farbe
    border.width: Globals.borderWidth

    radius: Globals.borderRadius

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 250
        }
    }

    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: mouseArea.containsMouse ? Colors.color0 : button.farbe

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
