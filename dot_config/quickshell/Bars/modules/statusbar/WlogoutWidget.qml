import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Wayland

import qs.singletons
import qs.modules.components

PopupWindow {
    id: root

    required property PanelWindow haftung

    color: "transparent"

    visible: implicitHeight > 1 ? true : false

    implicitWidth: column.width
    implicitHeight: System.wlogoutOpen ? column.height : 1

    anchor.window: haftung

    anchor.rect.x: 318 // (1920 / 2) - (root.implicitWidth / 2)
    anchor.rect.y: -158

    Behavior on implicitHeight {
        NumberAnimation {
            duration: Globals.animationDuration
        }
    }

    Column {
        id: column
        spacing: 4

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
