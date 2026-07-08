import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

Entry {
    hintergrund: Colors.background
    farbe: Colors.color1
    inhalt: Power.getText()

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Power.nextProfile()
    }
}
