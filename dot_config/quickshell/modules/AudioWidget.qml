import QtQuick

import qs.singletons
import qs.popups
import qs.components

Widget {
    id: root

    text: Audio.icon

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: root.forceActiveFocus()
        onClicked: Globals.togglePopup(popup)
    }

    AudioPopup {
        id: popup
        target: root
    }
}
