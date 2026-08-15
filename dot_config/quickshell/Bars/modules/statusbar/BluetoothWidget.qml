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
    inhalt: Bluetooth.getText()

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Bluetooth.toggleDevice()

        onWheel: event => {
            if (event.angleDelta.y > 0) {
                Bluetooth.deviceIndex = (Bluetooth.deviceIndex - 1 + Bluetooth.deviceCount) % Bluetooth.deviceCount;
            } else {
                Bluetooth.deviceIndex = (Bluetooth.deviceIndex + 1) % Bluetooth.deviceCount;
            }

            root.inhalt = Bluetooth.getText(true);
        }

        onHoveredChanged: {
            if (!mouseArea.containsMouse)
                Bluetooth.deviceIndex = 0;

            root.inhalt = Bluetooth.getText(mouseArea.containsMouse);
        }
    }

    Connections {
        target: Bluetooth.deviceSelected

        function onConnectedChanged() {
            root.inhalt = Bluetooth.getText(mouseArea.containsMouse);
        }
    }
}
