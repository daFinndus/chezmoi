import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

Entry {
    hintergrund: Colors.color1
    farbe: Colors.color0
    inhalt: Power.getText()

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Power.nextProfile()
    }
}
