import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons
import qs.modules.components

Entry {
    id: root

    width: 82

    hintergrund: Colors.color1
    farbe: Colors.color0
    inhalt: Wlogout.getText()

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Wlogout.startSystemFunction()

        onWheel: event => {
            if (event.angleDelta.y > 0) {
                Wlogout.wlogoutIndex = (Wlogout.wlogoutIndex - 1 + Wlogout.systemFunctions.length) % Wlogout.systemFunctions.length;
            } else {
                Wlogout.wlogoutIndex = (Wlogout.wlogoutIndex + 1) % Wlogout.systemFunctions.length;
            }

            root.inhalt = Wlogout.getText(true);
        }

        onHoveredChanged: {
            if (!mouseArea.containsMouse)
                Wlogout.wlogoutIndex = 0;

            root.inhalt = Wlogout.getText(mouseArea.containsMouse);
        }
    }
}
