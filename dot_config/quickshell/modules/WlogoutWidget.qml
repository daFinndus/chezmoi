import QtQuick

import qs.singletons
import qs.popups
import qs.components

Widget {
    id: root

    property int systemIndex: 0
    onSystemIndexChanged: root.text = Wlogout.getText(root.systemIndex)

    text: Themes.iconMode ? "\uf08b" : "System"

    Keys.enabled: !Themes.iconMode
    Keys.onPressed: event => {
        switch (event.key) {
        case Qt.Key_Up:
            root.systemIndex = (root.systemIndex - 1 + Wlogout.systemFunctions.length) % Wlogout.systemFunctions.length;
            break;
        case Qt.Key_Down:
            root.systemIndex = (root.systemIndex + 1) % Wlogout.systemFunctions.length;
            break;
        case Qt.Key_Return:
            Wlogout.startSystemfunction(Wlogout.systemFunctions[root.systemIndex].command);
            break;
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: !Themes.iconMode
        cursorShape: Qt.PointingHandCursor

        onClicked: Themes.iconMode ? Globals.togglePopup(popup) : Wlogout.startSystemFunction(Wlogout.systemFunctions[root.systemIndex].command)

        onEntered: {
            if (!Themes.iconMode) {
                root.forceActiveFocus();
                root.text = Wlogout.getText(root.systemIndex);
            }
        }

        onExited: {
            if (!Themes.iconMode) {
                root.systemIndex = 0;
                root.text = "System";
            }
        }

        onWheel: event => {
            if (!Themes.iconMode) {
                if (event.angleDelta.y > 0) {
                    root.systemIndex = (root.systemIndex - 1 + Wlogout.systemFunctions.length) % Wlogout.systemFunctions.length;
                } else {
                    root.systemIndex = (root.systemIndex + 1) % Wlogout.systemFunctions.length;
                }
            }
        }
    }

    WlogoutPopup {
        id: popup
        target: root
    }
}
