import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons
import qs.modules.components

Entry {
    id: root
    hintergrund: Colors.background
    farbe: Colors.color1
    inhalt: `${Updates.updateCount} Updates`

    opacity: Updates.updateCount > 0 ? 1 : 0
    visible: opacity > 0

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Updates.runUpdateScript()
    }
}
