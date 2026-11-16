import QtQuick

import qs.singletons
import qs.components

Popup {
    id: popup

    icon: Dunst.icon

    MouseArea {
        anchors.fill: parent

        onClicked: Dunst.toggleDaemon()
    }
}
