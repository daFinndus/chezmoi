import QtQuick

import qs.popups
import qs.singletons
import qs.components

Widget {
    id: root

    text: Themes.iconMode ? "\ue7d5" : "Profile: " + Power.getText()

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Themes.iconMode ? Globals.togglePopup(popup) : Power.nextProfile()
    }

    PowerPopup {
        id: popup
        target: root
    }
}
