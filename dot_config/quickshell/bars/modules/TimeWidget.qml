import QtQuick

import qs.singletons
import qs.bars.modules.components

Widget {
    id: root

    text: mouseArea.containsMouse ? Time.date : Time.shortTime

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }
}
