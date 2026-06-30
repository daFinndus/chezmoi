import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland

import qs.singletons
import qs.modules.taskbar

Scope {
    id: root

    PanelWindow {
        id: taskbar

        // This is needed so widgets can be focused for the keyboard
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        property int margin: 2

        visible: !Globals.statusbarVisible

        color: "transparent"

        anchors.top: true

        implicitWidth: 1920 - margin * 2
        implicitHeight: Globals.barHeight

        WlogoutWidget {
            haftung: taskbar
        }

        MediaWidget {
            id: media
        }

        RowLayout {
            id: layout

            anchors.fill: parent

            Row {
                spacing: 4

                TimeWidget {}
                WorkspaceWidget {}
                InhibitorWidget {}
                PowerWidget {}
                TrayWidget {}
            }

            Item {
                Layout.fillWidth: true
            }

            Row {
                spacing: 4

                UpdateWidget {}
                NetworkWidget {}
                VolumeWidget {}
                SystemWidget {}
            }
        }
    }
}
