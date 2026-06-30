import QtQuick
import Quickshell.Io

import qs.singletons
import qs.modules.components

Rect {
    id: root

    inhalt: Battery.getText()
    farbe: getColor()

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (Battery.loading) {
                if (root.inhalt == Battery.getEstimate()) {
                    root.inhalt = Battery.battery + " at: " + Battery.percentage + "%";
                } else {
                    root.inhalt = Battery.getEstimate();
                }
            }
        }

        onEntered: {
            if (Battery.loading) {
                root.inhalt = Battery.battery + " at: " + Battery.percentage + "%";
            } else {
                root.inhalt = Battery.getEstimate();
            }
        }

        onExited: root.inhalt = Battery.getText()
    }

    function getColor() {
        if (Battery.percentage >= 80) {
            return Colors.color1;
        } else if (Battery.percentage >= 50) {
            return Colors.color2;
        } else if (Battery.percentage >= 25) {
            return Colors.color3;
        } else if (Battery.percentage >= 5) {
            return Colors.color4;
        } else {
            return Colors.color5;
        }
    }
}
