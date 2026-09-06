import QtQuick

import qs.singletons
import qs.bars.components

Widget {
    id: root

    text: Power.getText()

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Power.nextProfile()
    }
}
