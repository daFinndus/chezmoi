import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

Item {
    id: root

    property bool open: true

    Rectangle {
        id: button
        width: 80
        height: 40
        radius: open ? 10 : 8
        color: Colors.colors.background

        MouseArea {
            anchors.fill: parent
            onClicked: root.open = !root.open
        }
    }

    Rectangle {
        id: dropdown
        y: button.height
        width: button.width
        height: open ? 120 : 0
        opacity: open ? 1 : 0
        clip: true

        color: Colors.colors.background

        Behavior on height {
            NumberAnimation { duration: 200 }
        }

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
    }
}