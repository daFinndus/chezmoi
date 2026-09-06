import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland

import Qt5Compat.GraphicalEffects

import qs.singletons
import qs.bars.modules
import qs.bars.components

Scope {
    id: root

    PanelWindow {
        id: panel

        aboveWindows: false

        // This is needed so widgets can be focused for the keyboard
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        color: Themes.transparentBackground ? "transparent" : Colors.background

        anchors.top: true

        implicitWidth: 1920
        implicitHeight: Themes.barHeight

        MouseArea {
            id: mouseArea

            anchors.fill: parent

            onDoubleClicked: Themes.transparentBackground = !Themes.transparentBackground
        }

        Item {
            anchors.fill: parent

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                SystemWidget {
                    background: "transparent"
                    shade: Themes.transparentBackground ? Colors.color0 : Colors.color5
                }

                WorkspaceWidget {
                    background: "transparent"
                    shade: Themes.transparentBackground ? Colors.color0 : Colors.color5
                    accent: Themes.transparentBackground ? Colors.color0 : Colors.color5
                }
            }

            TimeWidget {
                anchors.centerIn: parent

                background: "transparent"
                shade: Themes.transparentBackground ? Colors.color0 : Colors.color5

                text: Time.day

                icon: false
            }

            Row {
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                BluetoothWidget {
                    background: "transparent"
                    shade: Themes.transparentBackground ? Colors.color0 : Colors.color5
                }

                NetworkWidget {
                    background: "transparent"
                    shade: Themes.transparentBackground ? Colors.color0 : Colors.color5
                }

                VolumeWidget {
                    background: "transparent"
                    shade: Themes.transparentBackground ? Colors.color0 : Colors.color5
                }

                WlogoutWidget {
                    background: "transparent"
                    shade: Themes.transparentBackground ? Colors.color0 : Colors.color5
                }
            }
        }
    }
}
