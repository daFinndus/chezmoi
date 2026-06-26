import QtQuick
import Quickshell

import qs.singletons

Rectangle {
    id: root

    width: text.implicitWidth
    height: statusbar.height

    color: Colors.color1

    Text {
        id: text

        font.pixelSize: Globals.fontSize / 1.25

        leftPadding: 8
        rightPadding: 8

        anchors.verticalCenter: parent.verticalCenter

        text: "/: " + Hardware.rootDisk + "   " + "/home: " + Hardware.homeDisk
        color: Colors.color0
    }
}
