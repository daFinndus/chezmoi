import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland

import qs.singletons
import qs.modules
import qs.popups
import qs.components

Scope {
    id: root

    PanelWindow {
        id: panel

        WlrLayershell.aboveWindows: false

        // This is for blur maybe
        WlrLayershell.namespace: "quattro-taskbar"

        // Do not set this color to anything non-transparent
        // It will basically override hyprlands layer rule for blur
        color: "transparent"

        anchors.top: true

        implicitWidth: panel.screen.width
        implicitHeight: Themes.barHeight

        Rectangle {
            color: Globals.withAlpha(Themes.background, Themes.transparency)
            anchors.fill: parent

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                BatteryPopup {}

                SystemPopup {}

                WorkspaceWidget {
                    background: "transparent"
                    accent: Themes.shade
                }
            }

            TimeWidget {
                anchors.centerIn: parent

                background: "transparent"
                shade: Themes.shade

                text: Time.day

                icon: false
            }

            Row {
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                TrayWidget {}

                UpdateWidget {
                    background: "transparent"
                }

                PowerPopup {}

                InhibitorWidget {
                    background: "transparent"
                }

                BluetoothPopup {}

                VirtualPopup {}

                NetworkPopup {}

                AudioPopup {}

                WlogoutPopup {}
            }
        }
    }
}
