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
        cursorShape: Qt.PointingHandCursor

        onClicked: Themes.iconMode ? Globals.togglePopup(popup) : null
    }

    BatteryPopup {
        id: popup
        target: root
    }
}
