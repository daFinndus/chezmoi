import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

Text {
    font.pixelSize: Globals.fontSize / 1.25

    text: mouseArea.containsMouse ? Time.date : Time.shortTime

    leftPadding: 8
    rightPadding: 8

    color: "#ffffff"

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: Themes.switchTheme()
    }
}
