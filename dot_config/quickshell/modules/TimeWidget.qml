import QtQuick

import qs.singletons
import qs.components

Widget {
    id: root

    text: mouseArea.containsMouse ? Time.date : Time.day

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        hoverEnabled: true
    }
}
