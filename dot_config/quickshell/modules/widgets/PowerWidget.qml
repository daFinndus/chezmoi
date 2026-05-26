import QtQuick
import Quickshell
import Quickshell.Services.UPower 

import qs.singletons
import qs.modules.components

Rect {
    farbe: getColor()
    inhalt: `Profile: ${getProfile()}`

    property int power: PowerProfiles.profile

    function getProfile() {
        switch (power) {
        case 0:
            return "Chillin'"
        case 1:
            return "Balanced"
        case 2:
            return "Performance"
        default:
            return "Unknown"
        }
    }

    function getColor() {
        switch (power) {
        case 0:
            return Colors.colors.green
        case 1:
            return Colors.colors.orange
        case 2:
            return Colors.colors.red
        default:
            return Colors.colors.gray
        }
    }

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            PowerProfiles.profile = (power + 1) % 3
        }
    }
}
