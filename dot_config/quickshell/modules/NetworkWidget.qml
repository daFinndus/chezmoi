import QtQuick

import qs.singletons
import qs.popups
import qs.components

Widget {
    id: root

    text: Network.getText()

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        acceptedButtons: Qt.LeftButton

        onClicked: Themes.iconMode ? Globals.togglePopup(popup) : Network.startIwctl()
    }

    NetworkPopup {
        id: popup
        target: root
    }
}
