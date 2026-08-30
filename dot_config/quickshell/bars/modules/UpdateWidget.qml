import QtQuick
import Quickshell
import Quickshell.Io

import qs.singletons
import qs.bars.modules.components

Widget {
    id: root

    text: `${Updates.updateCount} Updates`

    opacity: Updates.updateCount > 0 ? 1 : 0
    visible: root.opacity > 0

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Updates.runUpdateScript()
        onHoveredChanged: Updates.widgetHovered = !Updates.widgetHovered
    }
}
