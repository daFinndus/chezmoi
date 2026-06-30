import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons
import qs.modules.components

Rect {
    farbe: getColor()
    inhalt: Network.getText()

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        acceptedButtons: Qt.LeftButton

        onClicked: Network.startIwctl()
    }

    function getColor() {
        if (Network.online) {
            return Colors.color1;
        } else {
            return Colors.color2;
        }
    }
}
