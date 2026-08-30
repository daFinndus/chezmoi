import QtQuick

import qs.singletons
import qs.bars.modules.components

Widget {
    id: root

    text: Network.online ? Network.toggler ? Network.speed : "up: " + Network.hardware : "down: network"

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        acceptedButtons: Qt.LeftButton

        onClicked: Network.startIwctl()
    }
}
