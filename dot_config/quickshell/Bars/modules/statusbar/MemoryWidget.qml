import QtQuick
import Quickshell

import qs.singletons

Rectangle {
    id: root

    width: text.implicitWidth
    height: statusbar.height

    color: Colors.color0

    Behavior on width {
        NumberAnimation {
            duration: Globals.animationDuration / 2
        }
    }

    Text {
        id: text

        font.pixelSize: Globals.fontSize / 1.25

        leftPadding: 4
        rightPadding: 4

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        text: "R: " + Hardware.loadRAM
        color: Colors.color1
    }
}
