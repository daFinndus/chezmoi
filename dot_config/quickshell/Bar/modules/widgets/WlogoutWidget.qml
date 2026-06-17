import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Wayland

import qs.singletons
import qs.modules.widgets
import qs.modules.components

PopupWindow {
    id: window

    default property list<var> children: [
        {
            command: "systemctl poweroff",
            inhalt: "Shutdown"
        },
        {
            command: "systemctl reboot",
            inhalt: "Reboot"
        },
        {
            command: "systemctl suspend",
            inhalt: "Suspend"
        },
        {
            command: "hyprctl dispatch 'hl.dsp.exit()'",
            inhalt: "Logout"
        },
        {
            command: "hyprlock",
            inhalt: "Lock"
        }
    ]

    color: "transparent"

    visible: implicitHeight > 1 ? true : false

    implicitWidth: 128
    implicitHeight: Globals.wlogoutOpen ? column.height : 1

    anchor.window: bar

    anchor.rect.x: bar.width - 128
    anchor.rect.y: bar.height + 8

    Behavior on implicitHeight {
        NumberAnimation {
            duration: Globals.animationDuration
        }
    }

    Column {
        id: column

        anchors.top: parent.top

        spacing: 8

        Repeater {
            model: window.children

            delegate: SystemButton {
                required property var modelData

                command: modelData.command
                inhalt: modelData.inhalt
            }
        }
    }
}
