import QtQuick
import Quickshell
import QtQuick.Layouts

import qs.singletons
import qs.modules.widgets

Scope {
    id: root

    PanelWindow {
        id: window

        property int margin: 8

        color: "transparent"

        anchors.top: true
        margins.top: margin
        
        implicitHeight: Globals.barHeight
        implicitWidth: 1920 - margin * 2

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

            Item { Layout.fillWidth: true }

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
