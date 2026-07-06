import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

PopupWindow {
    id: root

    required property Item systemWidget

    color: "transparent"

    visible: implicitHeight > 1

    onVisibleChanged: {
        console.log("root.implicitWidth:", root.implicitWidth)
        console.log("column.width:", column.width)
        console.log("anchor.rect.x", anchor.rect.x)
        console.log("anchor.rect.y", anchor.rect.y)
        console.log("systemWidget.width:", systemWidget.width)
    }

    implicitWidth: 128
    implicitHeight: System.wlogoutOpen ? column.height : 1

    anchor.margins {
        right: 0
        top: Globals.barHeight + 8
        left: 0
        bottom: 0
    }

    anchor.item: systemWidget
    anchor.gravity: Edges.Bottom | Edges.Right

    Behavior on implicitHeight {
        NumberAnimation {
            duration: Globals.animationDuration / 2
        }
    }

    Column {
        id: column
        spacing: 8

        Repeater {
            model: System.systemFunctions

            delegate: SystemButton {
                required property var modelData

                command: modelData.command
                inhalt: modelData.inhalt
            }
        }
    }
}
