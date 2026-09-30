import QtQuick

import qs.singletons
import qs.components

Widget {
    id: root

    text: Themes.iconMode ? "\udb81\udeb0" : `${Updates.updateCount} Updates`

    opacity: Updates.updateCount > 0 ? 1 : 0
    visible: root.opacity > 0

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Updates.runUpdateScript()
        onHoveredChanged: if (Themes.iconMode) {
            delayTooltip.start();
        } else {
            Updates.widgetHovered = mouseArea.containsMouse;
        }
    }

    Tooltip {
        id: tooltip
        target: root
        text: `${Updates.updateCount} Updates`
    }

    Timer {
        id: delayTooltip
        interval: 150
        onTriggered: tooltip.available = mouseArea.containsMouse
    }
}
