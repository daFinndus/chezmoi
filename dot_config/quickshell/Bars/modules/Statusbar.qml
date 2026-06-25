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

                TimeWidget {}
            }

            Item {
                Layout.fillWidth: true
            }

            Row {
                spacing: 8

                NetworkWidget {}
                HardwareWidget {}
            }
        }
    }
}
