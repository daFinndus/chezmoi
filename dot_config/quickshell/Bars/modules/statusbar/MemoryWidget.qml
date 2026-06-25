import QtQuick
import Quickshell

import qs.singletons

Rectangle {
    id: rect

    width: text.implicitWidth
    height: statusbar.height

    color: Colors.color0

    Text {
        id: text

        font.pixelSize: Globals.fontSize / 1.25

        leftPadding: 8
        rightPadding: 8

        anchors.verticalCenter: parent.verticalCenter

        text: "R: " + Hardware.loadRAM
        color: Colors.color1
    }
}
