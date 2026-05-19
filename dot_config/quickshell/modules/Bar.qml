import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.widgets
import qs.singletons

Scope {
    id: root

    PanelWindow {
        id: toplevel

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
                UpdateWidget {}
            }

            Item {
                Layout.fillWidth: true
            }

            Row {
                spacing: 4

                TrayWidget {}
                NetworkWidget {}
                VolumeWidget {}
                SystemWidget {}
            }
        }

        TrayPopupWidget {}
    }
}
