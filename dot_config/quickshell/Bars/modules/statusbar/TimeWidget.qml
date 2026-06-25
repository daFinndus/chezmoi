import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

Rectangle {
    id: rect

    width: text.implicitWidth
    height: statusbar.height

    color: Colors.color1

    Text {
        id: text

        font.pixelSize: Globals.fontSize / 1.25

        text: mouseArea.containsMouse ? Time.date : Time.shortTime

        leftPadding: 8
        rightPadding: 8

        anchors.verticalCenter: parent.verticalCenter

        color: Colors.color0

        MouseArea {
            id: mouseArea

            anchors.fill: parent

            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }
}
