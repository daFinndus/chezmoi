import QtQuick

import qs.popups
import qs.singletons
import qs.components

Widget {
    id: root

    text: Battery.text

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}
