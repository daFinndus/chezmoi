import QtQuick

import qs.singletons
import qs.components

Popup {
    id: popup

    icon: Dunst.icon

    MouseArea {
        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor
        onClicked: Dunst.toggleDaemon()
    }
}
