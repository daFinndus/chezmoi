import QtQuick

import qs.popups
import qs.singletons
import qs.components

Widget {
    id: root

    text: Power.icon

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        onHoveredChanged: delayTooltip.start()

        cursorShape: Qt.PointingHandCursor
        onClicked: Globals.togglePopup(popup)
    }

    Tooltip {
        id: tooltip
        target: root
        text: Power.text
    }

    Timer {
        id: delayTooltip
        interval: 150
        onTriggered: tooltip.available = mouseArea.containsMouse
    }

    PowerPopup {
        id: popup
        target: root
    }
}
