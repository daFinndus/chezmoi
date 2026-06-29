import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons
import qs.modules.components

Button {
    id: root

    farbe: getColor()
    inhalt: `${Updates.updateCount} Updates`

    opacity: Updates.updateCount > 0 ? 1 : 0
    visible: opacity > 0 ? 1 : 0

    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }
    }

    function getColor() {
        if (Updates.updatesLoaded) {
            if (Updates.updateCount == 0) {
                return Colors.color2;
            } else if (Updates.updateCount > 0 && Updates.updateCount < 12) {
                return Colors.color6;
            } else {
                return Colors.color12;
            }
        } else {
            return Colors.color2;
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Updates.runUpdateScript()
    }
}
