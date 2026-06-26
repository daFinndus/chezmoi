import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Wayland

import qs.singletons
import qs.modules.statusbar

Scope {
    id: root

    PanelWindow {
        id: statusbar

        // This is needed so widgets can be focused for the keyboard
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        property int margin: 4

        color: Colors.background

        anchors.bottom: true

        visible: Globals.statusbarVisible

        implicitHeight: Globals.barHeight / 1.25
        implicitWidth: 1920

        RowLayout {
            id: layout

            anchors.fill: parent

            Row {
                spacing: 8

                WorkspaceWidget {}
                TimeWidget {}
                InhibitorWidget {}
                UpdateWidget {}
            }

            Item {
                Layout.fillWidth: true
            }

            Row {
                spacing: 8

                NetworkWidget {}
                VolumeWidget {}
                ProcessorWidget {}
                GraphicsWidget {}
                MemoryWidget {}
                DiskWidget {}
            }
        }
    }

    Component.onCompleted: {
        Hardware.updateHardware();
    }
}
