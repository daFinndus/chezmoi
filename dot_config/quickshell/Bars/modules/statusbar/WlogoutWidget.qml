import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Wayland

import qs.singletons
import qs.modules.components

PopupWindow {
    id: root

    required property Item systemWidget

    color: "transparent"

    visible: implicitHeight > 1

    implicitWidth: column.width
    implicitHeight: System.wlogoutOpen ? column.height : 1

    anchor.margins {
        right: 0
        top: 0
        left: 0
        bottom: 0
    }

    anchor.item: systemWidget
    anchor.gravity: Edges.Top | Edges.Right

    Behavior on implicitHeight {
        NumberAnimation {
            duration: Globals.animationDuration / 2
        }
    }

    Column {
        id: column

        Repeater {
            model: System.systemFunctions

            delegate: SystemEntry {
                required property var modelData

                width: 60

                command: modelData.command
                inhalt: modelData.inhalt
            }
        }
    }
}
