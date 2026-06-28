import QtQuick
import Quickshell

import qs.singletons

Rectangle {
    id: root

    required property string hintergrund
    required property string farbe
    required property string inhalt

    width: text.implicitWidth + 8
    height: statusbar.height

    color: root.hintergrund

    Behavior on width {
        NumberAnimation {
            duration: Globals.animationDuration / 2
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }
    }

    Text {
        id: text

        font.pixelSize: Globals.fontSize / 1.25

        leftPadding: 4
        rightPadding: 4

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        text: root.inhalt
        color: root.farbe

        Behavior on color {
            ColorAnimation {
                duration: 500
                easing.type: Easing.OutCubic
            }
        }
    }
}
