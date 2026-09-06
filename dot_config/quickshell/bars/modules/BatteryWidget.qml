import QtQuick

import qs.singletons
import qs.bars.components

Widget {
    id: root

    text: Battery.getText()

    visible: Battery.available

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (Battery.loading) {
                if (root.text == Battery.getEstimate()) {
                    root.text = Battery.battery + " at: " + Battery.percentage + "%";
                } else {
                    root.text = Battery.getEstimate();
                }
            }
        }

        onEntered: {
            if (Battery.loading) {
                root.text = Battery.battery + " at: " + Battery.percentage + "%";
            } else {
                root.text = Battery.getEstimate();
            }
        }

        onExited: root.text = Battery.getText()
    }
}
