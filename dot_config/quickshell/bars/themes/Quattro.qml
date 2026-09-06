import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland

import Qt5Compat.GraphicalEffects

import qs.singletons
import qs.bars.modules

Scope {
    id: root

    PanelWindow {
        id: quattro

        aboveWindows: false

        // This is needed so widgets can be focused for the keyboard
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        property int margin: 2

        color: "#6361605a"

        anchors.top: true

        implicitWidth: 1920 - margin * 2
        implicitHeight: Themes.barHeight

        RowLayout {
            id: layout

            anchors.fill: parent

            Row {
                spacing: 4

                WlogoutWidget {
                    background: "transparent"
                    shade: Colors.color5
                }

                TrayWidget {}
            }

            Item {
                Layout.fillWidth: true
            }

            Row {
                TimeWidget {
                    background: "transparent"
                    shade: Colors.color5
                }

                spacing: 4
            }
        }
    }
}
