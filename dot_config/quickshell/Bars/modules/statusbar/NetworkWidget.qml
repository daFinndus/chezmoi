import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

Entry {
    id: root

    hintergrund: Colors.background
    farbe: Network.online ? Colors.color1 : Colors.color6
    inhalt: Network.online ? Network.toggler ? Network.speed : "up: " + Network.hardware : "down: " + Network.hardware

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        acceptedButtons: Qt.LeftButton

        onClicked: Network.startIwctl()
    }
}
