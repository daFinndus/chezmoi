import QtQuick

import qs.singletons
import qs.components

Widget {
    id: root

    text: mouseArea.containsMouse ? Time.date : Time.shortTime

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onHoveredChanged: delayTooltip.start()
    }

    Tooltip {
        id: tooltip
        target: root
        text: Time.fullTime
    }

    Timer {
        id: delayTooltip
        interval: 150
        onTriggered: tooltip.available = mouseArea.containsMouse
    }
}
