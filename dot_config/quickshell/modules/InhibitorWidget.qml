import QtQuick

import qs.singletons
import qs.components

Widget {
    id: root

    text: Inhibitor.icon

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor
        onClicked: Inhibitor.inhibited = !Inhibitor.inhibited
    }
}
