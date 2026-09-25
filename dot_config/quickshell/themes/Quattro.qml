import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland

import Qt5Compat.GraphicalEffects

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

        implicitWidth: 1920
        implicitHeight: Themes.barHeight

        MouseArea {
            id: mouseArea

            anchors.fill: parent

            onDoubleClicked: {
                Themes.transparentBackground = !Themes.transparentBackground;
                Themes.transparency = 0.5;
            }

            onWheel: event => {
                Themes.transparency += (event.angleDelta.y / 120) / 20;
                Themes.transparency = Globals.clamp(0, 1, Themes.transparency);
            }
        }

        Rectangle {
            color: Qt.rgba(Themes.background.r, Themes.background.g, Themes.background.b, Themes.transparency)
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

                TrayWidget {}
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

                NetworkWidget {
                    background: "transparent"
                }

                VolumeWidget {
                    background: "transparent"
                }

                WlogoutWidget {
                    background: "transparent"
                }
            }
        }
    }
}
