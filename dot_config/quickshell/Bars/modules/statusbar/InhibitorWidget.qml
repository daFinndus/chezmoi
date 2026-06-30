import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.singletons
import qs.modules.components

Entry {
    id: root

    hintergrund: Colors.background
    farbe: Colors.color1
    inhalt: Inhibitor.inhibited ? "Inhibitor: Active" : "Inhibitor: Inactive"

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            Inhibitor.inhibited = !Inhibitor.inhibited;
        }
    }
}
