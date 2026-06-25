import QtQuick
import Quickshell

import qs.singletons

Rectangle {
    id: rect

    width: text.implicitWidth
    height: statusbar.height

    color: Colors.color1

    property string speed: Network.download + " " + Network.upload
    property bool toggler: false

    Text {
        id: text

        font.pixelSize: Globals.fontSize / 1.25

        leftPadding: 8
        rightPadding: 8

        anchors.verticalCenter: parent.verticalCenter

        text: Network.online ? toggler ? speed : "up: " + Network.hardware : "down: " + Network.hardware
        color: Network.online ? Colors.color6 : Colors.color0
    }

    Timer {
        interval: 6000

        running: true
        repeat: true

        onTriggered: toggler = !toggler
    }
}
