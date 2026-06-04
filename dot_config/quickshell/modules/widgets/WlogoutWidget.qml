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
            inhalt: "Power On"
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
            command: "systemctl hibernate",
            inhalt: "Hibernate"
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

    property bool existant: false

    color: "transparent"

    visible: Globals.wlogoutOpen

    implicitWidth: grid.width
    implicitHeight: grid.height

    anchor.window: bar

    anchor.rect.x: bar.width - grid.width
    anchor.rect.y: bar.height + 8

    Timer {
        id: closeWlogout
        interval: Globals.wlogoutFadeDelay

        onTriggered: Globals.wlogoutOpen = false
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true

        onEntered: {
            Globals.wlogoutHovered = true;
        }

        onExited: {
            Globals.wlogoutClickable = false;
            Globals.wlogoutHovered = false;
            closeWlogout.start();
        }

        GridLayout {
            id: grid

            anchors.centerIn: parent

            columns: 1

            columnSpacing: 0
            rowSpacing: 8

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
}
