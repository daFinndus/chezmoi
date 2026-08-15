import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons

Rectangle {
    id: root

    width: 128
    height: Globals.barHeight

    color: Colors.color1

    border.color: Colors.color1
    border.width: Globals.borderWidth

    radius: Globals.borderRadius

    Behavior on width {
        NumberAnimation {
            duration: 250
        }
    }

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

            text.text = Wlogout.getText(true);
        }

        onHoveredChanged: {
            if (!mouseArea.containsMouse)
                Wlogout.wlogoutIndex = 0;

            text.text = Wlogout.getText(mouseArea.containsMouse);
        }
    }

    Text {
        id: text

        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontSize

        color: Colors.color0

        anchors.centerIn: parent

        text: Wlogout.getText()
    }
}
