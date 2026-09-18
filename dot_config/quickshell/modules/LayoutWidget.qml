import QtQuick

import qs.popups
import qs.singletons
import qs.components

Widget {
    id: root

    text: "\udb80\udc01"

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Globals.togglePopup(popup)
    }

    LayoutPopup {
        id: popup
        target: root
    }
}
