import QtQuick

import qs.singletons
import qs.bars.modules.components

Widget {
    id: root

    text: Wlogout.getText()

    Keys.onPressed: event => {
        switch (event.key) {
        case Qt.Key_Up:
            Wlogout.wlogoutIndex = (Wlogout.wlogoutIndex - 1 + Wlogout.systemFunctions.length) % Wlogout.systemFunctions.length;
            break;
        case Qt.Key_Down:
            Wlogout.wlogoutIndex = (Wlogout.wlogoutIndex + 1) % Wlogout.systemFunctions.length;
            break;
        case Qt.Key_Return:
            Wlogout.startSystemFunction();
            break;
        }

        root.text = Wlogout.getText(true);
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: root.forceActiveFocus()
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
