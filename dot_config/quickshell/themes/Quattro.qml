import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland

import qs.singletons
import qs.modules
import qs.components

Scope {
    id: root

    PanelWindow {
        id: panel

        WlrLayershell.aboveWindows: false

        // This is needed so widgets can be focused for the keyboard
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        // This is for blur maybe
        WlrLayershell.namespace: "quattro-taskbar"

        // Do not set this color to anything non-transparent
        // It will basically override hyprlands layer rule for blur
        color: "transparent"

        anchors.top: true

        implicitWidth: Screen.width
        implicitHeight: Themes.barHeight

        Rectangle {
            color: Globals.withAlpha(Themes.background, Themes.transparency)
            anchors.fill: parent

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                SystemWidget {
                    background: "transparent"
                }

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

                PowerWidget {
                    background: "transparent"
                }

                InhibitorWidget {
                    background: "transparent"
                }

                BluetoothWidget {
                    background: "transparent"
                }

                VirtualWidget {
                    background: "transparent"
                }

                NetworkWidget {
                    background: "transparent"
                }

                AudioWidget {
                    background: "transparent"
                }

                WlogoutWidget {
                    background: "transparent"
                }
            }
        }
    }
}
