import QtQuick

import qs.singletons
import qs.bars.components

Widget {
    id: root

    text: Inhibitor.inhibited ? "Inhibitor: Active" : "Inhibitor: Inactive"

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Inhibitor.inhibited = !Inhibitor.inhibited
    }
}
