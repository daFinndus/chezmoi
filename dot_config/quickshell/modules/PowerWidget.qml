import QtQuick

import qs.popups
import qs.singletons
import qs.components

Widget {
    id: root

    text: Power.text

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor
    }
}
