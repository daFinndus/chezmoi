import QtQuick

import qs.singletons
import qs.components

Widget {
    id: root

    text: Inhibitor.getText()

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Inhibitor.inhibited = !Inhibitor.inhibited
    }

    Tooltip {
        target: root
        text: Inhibitor.getText(true)
        available: Themes.iconMode && mouseArea.containsMouse
    }
}
