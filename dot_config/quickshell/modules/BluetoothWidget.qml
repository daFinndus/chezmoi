import QtQuick

import qs.singletons
import qs.popups
import qs.components

Widget {
    id: root

    text: Bluetooth.getText()

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Themes.iconMode ? Globals.togglePopup(popup) : Bluetooth.toggleDevice()

        onWheel: event => {
            if (event.angleDelta.y > 0) {
                Bluetooth.deviceIndex = (Bluetooth.deviceIndex - 1 + Bluetooth.deviceCount) % Bluetooth.deviceCount;
            } else {
                Bluetooth.deviceIndex = (Bluetooth.deviceIndex + 1) % Bluetooth.deviceCount;
            }

            root.text = Bluetooth.getText(true);
        }

        onHoveredChanged: {
            if (!mouseArea.containsMouse)
                Bluetooth.deviceIndex = 0;

            root.text = Bluetooth.getText(mouseArea.containsMouse);
        }
    }

    Connections {
        target: Bluetooth.deviceSelected

        function onConnectedChanged() {
            root.text = Bluetooth.getText(mouseArea.containsMouse);
        }
    }

    function togglePanel(): void {
        popup.available = !popup.available;
    }

    BluetoothPopup {
        id: popup
        target: root
    }
}
