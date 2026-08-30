import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland

import qs.singletons
import qs.bars.modules

Scope {
    id: root

    PanelWindow {
        id: blown

        aboveWindows: false

        // This is needed so widgets can be focused for the keyboard
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        property int margin: 2

        color: "transparent"

        margins.top: 2
        anchors.top: true

        implicitWidth: 1920 - margin * 2
        implicitHeight: Themes.barHeight

        RowLayout {
            id: layout

            anchors.fill: parent

            Row {
                spacing: 4

                TimeWidget {
                    background: Colors.background
                }

                WorkspaceWidget {
                    background: Colors.background
                    shade: Colors.color1
                    accent: Colors.color2
                }

                InhibitorWidget {
                    background: Inhibitor.inhibited ? Colors.color3 : Colors.background
                    shade: Inhibitor.inhibited ? Colors.color0 : Colors.color1
                }

                PowerWidget {
                    background: Colors.background
                }

                TrayWidget {}
            }

            Item {
                Layout.fillWidth: true
            }

            Row {
                spacing: 4

                UpdateWidget {
                    background: Updates.widgetHovered ? Colors.color3 : Colors.background
                    shade: Updates.widgetHovered ? Colors.color0 : Colors.color1
                }

                NetworkWidget {
                    background: Colors.background
                }

                VolumeWidget {
                    background: Colors.background
                }

                WlogoutWidget {
                    background: Wlogout.widgetHovered ? Colors.color3 : Colors.background
                    shade: Wlogout.widgetHovered ? Colors.color0 : Colors.color1
                }
            }
        }
    }
}
