import QtQuick

import qs.singletons
import qs.popups
import qs.components

Widget {
    id: root

    text: "Audio"

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: root.forceActiveFocus()
    }
}
