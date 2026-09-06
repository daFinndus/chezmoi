import QtQuick

import qs.singletons
import qs.bars.components

Widget {
    id: root

    text: mouseArea.containsMouse ? Time.date : Time.shortTime

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    Tooltip {
        target: root
        text: Time.fullTime
        available: mouseArea.containsMouse
    }
}
