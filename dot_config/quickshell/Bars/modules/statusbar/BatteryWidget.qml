import QtQuick
import Quickshell.Io

import qs.singletons
import qs.modules.components

Entry {
    id: root

    hintergrund: Colors.color1
    farbe: Colors.color0
    inhalt: Battery.getText()

    property int percentage: 0
    property string battery: ""
    property string status: ""
    property string estimate: ""
    property bool loading: false

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
}
