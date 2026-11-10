import QtQuick

import qs.singletons
import qs.components

Widget {
    id: root

    text: Inhibitor.icon

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        onHoveredChanged: delayTooltip.start()

        cursorShape: Qt.PointingHandCursor
        onClicked: Inhibitor.inhibited = !Inhibitor.inhibited
    }

    Tooltip {
        id: tooltip
        target: root
        text: Inhibitor.text
    }

    Timer {
        id: delayTooltip
        interval: 150
        onTriggered: tooltip.available = mouseArea.containsMouse
    }
}
