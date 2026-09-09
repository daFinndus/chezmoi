import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland

import qs.singletons
import qs.modules

Scope {
    id: root

    PanelWindow {
        id: blown

        WlrLayershell.aboveWindows: false

        // This is needed so widgets can be focused for the keyboard
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        property int margin: 2

        color: "transparent"

        margins.top: 2
        anchors.top: true

        implicitWidth: 1920 - margin * 2
        implicitHeight: Themes.barHeight

        Item {
            anchors.fill: parent

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                spacing: 4

                TimeWidget {
                    background: Themes.background
                }

                WorkspaceWidget {
                    background: Themes.background
                    shade: Themes.shade
                    accent: Colors.getColor(3)
                }

                InhibitorWidget {
                    background: Inhibitor.inhibited ? Colors.color3 : Themes.background
                    shade: Inhibitor.inhibited ? Colors.color0 : Themes.shade
                }

                PowerWidget {
                    background: Themes.background
                }
            }

            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                spacing: 4

                TrayWidget {}

                UpdateWidget {
                    background: Updates.widgetHovered ? Colors.color3 : Themes.background
                    shade: Updates.widgetHovered ? Colors.color0 : Themes.shade
                }

                NetworkWidget {
                    background: Themes.background
                }

                VolumeWidget {
                    background: Themes.background
                }

                WlogoutWidget {
                    background: Themes.background
                    shade: Themes.shade
                }
            }
        }
    }
}
