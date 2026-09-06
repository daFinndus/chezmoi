import QtQuick

import qs.singletons
import qs.bars.popups
import qs.bars.components

Widget {
    id: root

    property bool showPanel: false

    text: "\udb82\udcc7"

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: root.togglePanel()
    }

    function togglePanel(): void {
        root.showPanel = !root.showPanel;
    }

    SystemPopup {
        target: root
        available: root.showPanel
    }
}
