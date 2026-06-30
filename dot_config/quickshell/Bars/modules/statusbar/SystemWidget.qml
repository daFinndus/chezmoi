import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons
import qs.modules.components

Entry {
    id: root

    width: 60

    hintergrund: Colors.background
    farbe: Colors.color1
    inhalt: System.wlogoutOpen ? "Abort" : "System"

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: System.wlogoutOpen = !System.wlogoutOpen
    }
}
