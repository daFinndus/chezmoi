import QtQuick

import qs.popups
import qs.singletons
import qs.components

Widget {
    id: root

    text: Themes.iconMode ? Battery.getIcon() : Battery.getText()
    visible: Battery.hasBattery

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (Themes.iconMode) {
                Globals.togglePopup(popup);
            } else {
                if (Battery.loading) {
                    if (root.text == Battery.getEstimate()) {
                        root.text = Battery.battery + " at: " + Battery.percentage + "%";
                    } else {
                        root.text = Battery.getEstimate();
                    }
                }
            }
        }

        onHoveredChanged: {
            if (!Themes.iconMode) {
                if (mouseArea.containsMouse) {
                    if (Battery.loading) {
                        root.text = Battery.battery + " at: " + Battery.percentage + "%";
                    } else {
                        root.text = Battery.getEstimate();
                    }
                } else {
                    root.text = Battery.getText();
                }
            }
        }
    }

    BatteryPopup {
        id: popup
        target: root
    }
}
