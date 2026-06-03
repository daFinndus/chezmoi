import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Wayland

import qs.singletons
import qs.modules.widgets

Scope {
    id: root

    PanelWindow {
        id: bar

        property int margin: 8

        color: "transparent"

        anchors.top: true
        margins.top: margin

        implicitHeight: Globals.barHeight
        implicitWidth: 1920 - margin * 2

        RowLayout {
            id: layout

            anchors.fill: parent

            WlogoutWidget {}

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

                // DropWidget {}
                UpdateWidget {}
                NetworkWidget {}
                VolumeWidget {}
                SystemWidget {}
            }
        }
    }
}
