import QtQuick
import Quickshell

import qs.singletons
import qs.modules.components

Rectangle {
    id: root

    width: text.implicitWidth
    height: statusbar.height

    color: Colors.color1

    Behavior on width {
        NumberAnimation {
            duration: Globals.animationDuration / 2
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }

    Text {
        id: text

        font.pixelSize: Globals.fontSize / 1.25

        text: mouseArea.containsMouse ? Time.date : Time.shortTime

        leftPadding: 4
        rightPadding: 4

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        color: Colors.color0
    }
}
