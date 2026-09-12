import QtQuick

import qs.singletons
import qs.popups
import qs.components

Widget {
    id: root

    text: Themes.iconMode ? "\udb80\udcaf" : (mouseArea.containsMouse ? Bluetooth.getText() : "Bluetooth: " + (root.enabled ? "Active" : "Disabled"))

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Themes.iconMode ? Globals.togglePopup(popup) : Bluetooth.toggleAdapter()

        onWheel: event => {
            // Not needed in icon mode
            if (Themes.iconMode) {
                return;
            }

            if (event.angleDelta.y > 0) {
                Bluetooth.deviceIndex = (Bluetooth.deviceIndex - 1 + Bluetooth.devices.length) % Bluetooth.devices.length;
            } else {
                Bluetooth.deviceIndex = (Bluetooth.deviceIndex + 1) % Bluetooth.devices.length;
            }
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
