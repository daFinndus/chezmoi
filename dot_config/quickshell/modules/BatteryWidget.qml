import QtQuick

import qs.popups
import qs.singletons
import qs.components

Widget {
    id: root

    text: Battery.icon
    visible: Battery.batteryAvailable

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        onHoveredChanged: delayTooltip.start()

        cursorShape: Qt.PointingHandCursor
        onClicked: Themes.iconMode ? Globals.togglePopup(popup) : null
    }

    Tooltip {
        id: tooltip
        target: root
        text: Battery.text
    }

    Timer {
        id: delayTooltip
        interval: 150
        onTriggered: tooltip.available = mouseArea.containsMouse
    }

    BatteryPopup {
        id: popup
        target: root
    }
}
