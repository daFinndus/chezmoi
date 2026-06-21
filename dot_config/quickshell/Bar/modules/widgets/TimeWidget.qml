import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

Rect {
    farbe: Colors.color1
    inhalt: mouseArea.containsMouse ? Time.date : Time.shortTime

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}
