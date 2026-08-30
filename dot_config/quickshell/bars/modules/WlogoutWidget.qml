import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons
import qs.bars.modules.components

Widget {
    id: root

    text: Wlogout.getText()

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

            root.text = Wlogout.getText(true);
        }

        onHoveredChanged: {
            Wlogout.widgetHovered = !Wlogout.widgetHovered;

            if (!mouseArea.containsMouse) {
                Wlogout.wlogoutIndex = 0;
            }

            root.text = Wlogout.getText(mouseArea.containsMouse);
        }
    }
}
