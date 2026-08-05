import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.singletons
import qs.modules.components

Entry {
    id: root

    hintergrund: Colors.color1
    farbe: Colors.color0
    inhalt: Bluetooth.text

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}
