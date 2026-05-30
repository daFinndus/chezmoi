import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons
import qs.modules.components

Rect {
    farbe: getColor()
    inhalt: getText()

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        acceptedButtons: Qt.LeftButton

        onClicked: event => {
            switch (event.button) {
                case Qt.LeftButton:
                    startIwctl.running = true
                    break
            }
        }
    }

    Process {
        id: startIwctl

        command: ["kitty", "--title", "iwctl", "-e", "iwctl"]
    }

    function getColor() {
        if (Network.online) {
            return Colors.colors.green
        } else {
            return Colors.colors.red
        }
    }

    function getText() {
        if (Network.type === "none") {
            return "No network"
        } else {
            return `Connected via ${Network.type}`
        }
    }
}