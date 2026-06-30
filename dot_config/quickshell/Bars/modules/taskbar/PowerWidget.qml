import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

Rect {
    farbe: getColor()
    inhalt: Power.getText()

    function getColor() {
        switch (Power.power) {
        case 0:
            return Colors.color1;
        case 1:
            return Colors.color4;
        case 2:
            return Colors.color6;
        default:
            return Colors.color1;
        }
    }

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Power.nextProfile()
    }
}
