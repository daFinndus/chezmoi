import QtQuick

import qs.singletons
import qs.popups
import qs.components

Widget {
    id: root

    text: "Network"

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        acceptedButtons: Qt.LeftButton

        onClicked: Network.startIwctl()
    }
}
