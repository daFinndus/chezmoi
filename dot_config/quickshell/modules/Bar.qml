import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.widgets
import qs.singletons

Scope {
    id: root

    PanelWindow {
        required property var modelData
        property int margin: 8

        screen: modelData

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

            Row {
                spacing: 4

                TrayWidget {}
                NetworkWidget {}
                VolumeWidget {}
                SystemWidget {}
            }
        }
    }
}
