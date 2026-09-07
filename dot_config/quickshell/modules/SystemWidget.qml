import QtQuick

import qs.singletons
import qs.popups
import qs.components

Widget {
    id: root

    text: "\udb82\udcc7"

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Globals.togglePopup(popup)
    }

    SystemPopup {
        id: popup
        target: root
    }
}
